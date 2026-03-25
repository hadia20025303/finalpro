import 'package:flutter/material.dart';
import 'package:untitlednew2/core/theme/app_colors.dart';

import 'package:untitlednew2/core/widgets/custom_button.dart';

import '../../../../core/theme/ app_text_styles.dart';
import '../../../main/ui/screens/main_layout_screen.dart';
import 'home_screen.dart';

// ✅ ملاحظة للربط: تأكد من تطابق هذه الأسماء مع ما سيتم تعريفه في ApiConstants
// ونستخدمها عند إرسال الطلب (Request Body) للسيرفر.

class LocationFilterScreen extends StatefulWidget {
  const LocationFilterScreen({super.key});

  @override
  State<LocationFilterScreen> createState() => _LocationFilterScreenState();
}

class _LocationFilterScreenState extends State<LocationFilterScreen> {
  // ---------------------------------------------------------
  // ✅ القسم 1: المتحولات المسؤولة عن الربط (Variables)
  // هذه القيم هي التي سيتم إرسالها للباك إيند لاحقاً.
  // ---------------------------------------------------------
  String? _selectedCountry; // يمثل 'country_id' أو 'country_name'
  String? _selectedGovernorate; // يمثل 'governorate_id'
  String? _selectedArea; // يمثل 'area_id'

  // ---------------------------------------------------------
  // ✅ القسم 2: هيكل البيانات (Data Structure)
  // مستقبلاً: هذه البيانات ستأتي من الـ API عبر (GET Request)
  // ---------------------------------------------------------
  final Map<String, Map<String, List<String>>> _locationData = {
    "سوريا": {
      "دمشق": ["المزة", "كفرسوسة", "مشروع دمر", "المالكي", "البرامكة"],
      "ريف دمشق": ["جرمانا", "صحنايا", "القدسيا", "النبك"],
      "حلب": ["الجميلية", "الفرقان", "الشهباء", "الحمدانية"],
      "اللاذقية": ["المشروع العاشر", "الزراعة", "الكورنيش"],
      "طرطوس": ["الصفصافة", "بانياس", "الدريكيش"],
      "حمص": ["الوعر", "الإنشاءات", "خالد بن الوليد"],
    },
  };

  @override
  Widget build(BuildContext context) {
    // منطق استخراج القوائم بناءً على الاختيارات
    List<String> governorates = _selectedCountry != null
        ? _locationData[_selectedCountry]!.keys.toList()
        : [];

    List<String> areas =
        (_selectedCountry != null && _selectedGovernorate != null)
        ? _locationData[_selectedCountry]![_selectedGovernorate]!
        : [];

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
          textDirection: TextDirection.rtl, // لضمان الترتيب العربي
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                // ✅ جعل كل العناصر في المنتصف عرضياً
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- الهيدر: X يمين و AQAR يسار ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.darkNavy,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'AQAR',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // --- العنوان الترحيبي (متوسط الشاشة) ---
                  Text(
                    'حدد موقعك لسهولة\nالوصول للعقار',
                    textAlign: TextAlign.center, // ✅ نص موسط
                    style: AppTextStyles.font24Bold.copyWith(
                      fontSize: 28,
                      color: AppColors.darkNavy,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // --- حقول الاختيار (Dropdowns) ---

                  // 1. اختيار البلد (يبدأ فارغاً)
                  _buildLabel("البلد"),
                  _buildSelectBox(
                    value: _selectedCountry,
                    items: _locationData.keys.toList(),
                    hint: "اختر البلد",
                    onChanged: (val) {
                      setState(() {
                        _selectedCountry = val;
                        _selectedGovernorate = null; // إعادة تعيين عند التغيير
                        _selectedArea = null;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // 2. اختيار المحافظة
                  _buildLabel("المحافظة"),
                  _buildSelectBox(
                    value: _selectedGovernorate,
                    items: governorates,
                    hint: "اختر المحافظة",
                    onChanged: (val) {
                      setState(() {
                        _selectedGovernorate = val;
                        _selectedArea = null;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // 3. اختيار المنطقة
                  _buildLabel(" المنطقة"),
                  _buildSelectBox(
                    value: _selectedArea,
                    items: areas,
                    hint: _selectedGovernorate == null
                        ? "اختر المحافظة أولاً"
                        : "اختر المنطقة",
                    onChanged: (val) {
                      setState(() => _selectedArea = val);
                    },
                  ),

                  const SizedBox(height: 60),

                  // --- زر التطبيق النهائي ---
                  CustomButton(
                    text: 'تطبيق',
                    backgroundColor:
                        (_selectedGovernorate != null && _selectedArea != null)
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    onPressed:
                        (_selectedGovernorate != null && _selectedArea != null)
                        ? () {
                            // ---------------------------------------------------------
                            // ✅ ملاحظة للربط بالباك إيند:
                            // هنا نقوم بجمع القيم الثلاث وإرسالها لـ API البحث أو تخزينها
                            // مثال:
                            // Map<String, dynamic> filterData = {
                            //   "country": _selectedCountry,
                            //   "governorate": _selectedGovernorate,
                            //   "area": _selectedArea,
                            // };
                            // ---------------------------------------------------------

                            // ✅ التعديل: نمرر المنطقة المختارة للمنشورات لكي يتم تصفيتها
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainLayoutScreen(
                                  initialArea: _selectedArea,
                                ),
                              ),
                              (route) => false,
                            );
                          }
                        : null,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ويدجيت السيلكت الموحد والموسط
  Widget _buildSelectBox({
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?)? onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: value != null ? AppColors.accent : Colors.grey.shade300,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          isExpanded: true,
          icon: const Icon(Icons.expand_more, color: AppColors.accent),
          alignment:
              AlignmentDirectional.centerStart, // لضبط انبثاق القائمة لليمن
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkNavy,
                  ),
                ),
              ),
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
      child: Text(
        text,
        textAlign:
            TextAlign.right, // يضمن محاذاة التسمية لليمين فوق الحقل الموسط
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
