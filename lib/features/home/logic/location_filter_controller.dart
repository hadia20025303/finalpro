import 'package:get/get.dart';
// تأكد من استيراد الهيكل الرئيسي لربط الانتقال

import '../../main/ui/screens/main_layout_screen.dart';

class LocationFilterController extends GetxController {
  // ✅ 1. المتحولات التفاعلية (جاهزة للربط بالباك إيند)
  var selectedCountry = Rxn<String>();     // يمثل 'country_id'
  var selectedGovernorate = Rxn<String>(); // يمثل 'governorate_id'
  var selectedArea = Rxn<String>();        // يمثل 'area_id'

  // ✅ 2. هيكل البيانات (مستقبلاً يتم جلبه بطلب GET من السيرفر)
  final Map<String, Map<String, List<String>>> locationData = {
    "سوريا": {
      "دمشق": ["المزة", "كفرسوسة", "مشروع دمر", "المالكي", "البرامكة"],
      "ريف دمشق": ["جرمانا", "صحنايا", "القدسيا", "النبك"],
      "حلب": ["الجميلية", "الفرقان", "الشهباء", "الحمدانية"],
      "اللاذقية": ["المشروع العاشر", "الزراعة", "الكورنيش"],
      "طرطوس": ["الصفصافة", "بانياس", "الدريكيش"],
      "حمص": ["الوعر", "الإنشاءات", "خالد بن وليد"],
    },
  };

  // ✅ 3. وظائف التغيير
  void changeCountry(String? val) {
    selectedCountry.value = val;
    selectedGovernorate.value = null; // تصفير عند تغيير الأب
    selectedArea.value = null;
  }

  void changeGovernorate(String? val) {
    selectedGovernorate.value = val;
    selectedArea.value = null; // تصفير عند تغيير الأب
  }

  void changeArea(String? val) {
    selectedArea.value = val;
  }

  // ✅ 4. دالة التطبيق (الربط مع الهوم)
  void applyFilter() {
    if (selectedGovernorate.value != null && selectedArea.value != null) {
      // الانتقال للهيكل الرئيسي وتمرير المنطقة المختارة
      Get.offAll(
            () => MainLayoutScreen(initialArea: selectedArea.value),
        transition: Transition.cupertino,
      );
    }
  }
}