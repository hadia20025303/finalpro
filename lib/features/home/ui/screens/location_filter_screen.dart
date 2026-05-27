import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ إضافة GetX
import 'package:untitlednew2/core/theme/app_colors.dart';

import 'package:untitlednew2/core/widgets/custom_button.dart';
import '../../../../core/theme/ app_text_styles.dart';
import '../../logic/location_filter_controller.dart';

class LocationFilterScreen extends StatelessWidget {
  const LocationFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ حقن الكنترولر
    final LocationFilterController controller = Get.put(LocationFilterController());

    return Scaffold(
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
                  // --- الهيدر: X يمين و AQAR يسار كما طلبت ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.darkNavy, size: 28),
                        onPressed: () => Get.back(),
                      ),
                      const Text(
                        'AQAR',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 2),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // --- العنوان الموسط ---
                  Text(
                    'حدد موقعك لسهولة\nالوصول للعقار',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font24Bold.copyWith(fontSize: 28, color: AppColors.darkNavy, height: 1.3),
                  ),
                  const SizedBox(height: 15),
                  Container(width: 50, height: 4, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(10))),

                  const SizedBox(height: 50),

                  // --- حقول الاختيار التفاعلية (Obx) ---

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

                  const SizedBox(height: 60),

                  // --- زر التطبيق الموسط ---
                  Obx(() => CustomButton(
                    text: 'تطبيق',
                    backgroundColor: (controller.selectedGovernorate.value != null && controller.selectedArea.value != null)
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    onPressed: (controller.selectedGovernorate.value != null && controller.selectedArea.value != null)
                        ? () => controller.applyFilter()
                        : null,
                  )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ويدجيت السيلكت الموحد والموسط (كما في كودك الأصلي)
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