import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ إضافة GetX
import 'package:untitlednew2/core/theme/app_colors.dart';
import 'package:untitlednew2/core/widgets/custom_button.dart';
import 'package:untitlednew2/core/widgets/main_bottom_navbar.dart';
import 'package:untitlednew2/features/main/logic/main_layout_controller.dart';
import 'package:untitlednew2/core/controllers/auth_controller.dart';
import 'package:untitlednew2/core/utils/guest_guard.dart';
import 'package:untitlednew2/features/main/ui/screens/main_layout_screen.dart'; // استيراد الهيكل الرئيسي

import '../../../../core/theme/ app_text_styles.dart';
import '../../logic/location_filter_controller.dart';


class LocationFilterScreen extends StatelessWidget {
  const LocationFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن كنترولر الفلترة
    final LocationFilterController controller = Get.put(LocationFilterController());

    // حقن كنترولر الـ Layout للتحكم في أزرار البار السفلي
    final MainLayoutController mainLayoutController = Get.put(MainLayoutController());

    return Scaffold(
      backgroundColor: AppColors.background,

      // البار السفلي الموحد والمجمد تلقائياً للزوار عبر Obx
      bottomNavigationBar: Obx(() {
        final bool isLoggedIn = AuthController.to.isLoggedIn.value;

        return MainBottomNavbar(
          currentIndex: -1, // جعل التحديد -1 لكي لا تضيء أي أيقونة أثناء الفلترة
          onTap: (index) {
            if (index == 0) {
              // الرئيسية: مسموح للجميع ونمرر التبويب 0
              Get.offAll(() => const MainLayoutScreen(initialIndex: 0));
            } else {
              // التبويبات الأخرى محمية بالحارس (Guard) ونمرر التبويب المختار
              guardAction(() {
                Get.offAll(() => MainLayoutScreen(initialIndex: index));
              });
            }
          },
          onAddTap: () {
            guardAction(() {
              mainLayoutController.navigateToAddProperty();
            });
          },
        );
      }),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary.withOpacity(0.05), Colors.white],
          ),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- الهيدر: X يمين و AQAR يسار ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ✅ التعديل النهائي: عند الضغط على X نذهب للـ MainLayout (الهوم كزائر) حصراً
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.darkNavy, size: 28),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const MainLayoutScreen()),
                                (route) => false, // مسح كل الصفحات والذهاب للهوم
                          );
                        },
                      ),
                      const Text(
                        'AQAR',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 2),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // العنوان الموسط
                  Text(
                    'حدد موقعك لسهولة\nالوصول للعقار',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font24Bold.copyWith(fontSize: 28, color: AppColors.darkNavy, height: 1.3),
                  ),
                  const SizedBox(height: 15),
                  Container(width: 50, height: 4, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(10))),

                  const SizedBox(height: 40),

                  // حقول الاختيار التفاعلية (Obx)
                  _buildLabel("البلد"),
                  Obx(() => _buildSelectBox(
                    value: controller.selectedCountry.value,
                    items: controller.locationData.keys.toList(),
                    hint: "اختر البلد",
                    onChanged: (val) => controller.changeCountry(val),
                  )),

                  const SizedBox(height: 20),

                  _buildLabel("المحافظة"),
                  Obx(() {
                    List<String> governorates = controller.selectedCountry.value != null
                        ? controller.locationData[controller.selectedCountry.value]!.keys.toList()
                        : [];
                    return _buildSelectBox(
                      value: controller.selectedGovernorate.value,
                      items: governorates,
                      hint: "اختر المحافظة",
                      onChanged: (val) => controller.changeGovernorate(val),
                    );
                  }),

                  const SizedBox(height: 20),

                  _buildLabel("المنطقة"),
                  Obx(() {
                    List<String> areas = (controller.selectedCountry.value != null && controller.selectedGovernorate.value != null)
                        ? controller.locationData[controller.selectedCountry.value]![controller.selectedGovernorate.value]!
                        : [];
                    return _buildSelectBox(
                      value: controller.selectedArea.value,
                      items: areas,
                      hint: controller.selectedGovernorate.value == null ? "اختر المحافظة أولاً" : "اختر المنطقة",
                      onChanged: (val) => controller.changeArea(val),
                    );
                  }),

                  const SizedBox(height: 50),

                  // زر تطبيق الموسط
                  Obx(() => CustomButton(
                    text: 'تطبيق',
                    backgroundColor: (controller.selectedGovernorate.value != null && controller.selectedArea.value != null)
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    onPressed: (controller.selectedGovernorate.value != null && controller.selectedArea.value != null)
                        ? () => controller.applyFilter()
                        : null,
                  )),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ويدجيت السيلكت الموحد والموسط
  Widget _buildSelectBox({required String? value, required List<String> items, required String hint, required Function(String?)? onChanged}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: value != null ? AppColors.accent : Colors.grey.shade300, width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          isExpanded: true,
          icon: const Icon(Icons.expand_more, color: AppColors.accent),
          alignment: AlignmentDirectional.centerStart,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Align(alignment: Alignment.centerRight, child: Text(item, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkNavy))),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8, right: 5),
      child: Text(text, textAlign: TextAlign.right, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
    );
  }
}