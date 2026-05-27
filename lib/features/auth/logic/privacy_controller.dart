import 'package:get/get.dart';

import '../../home/ui/screens/location_filter_screen.dart'; // تأكد من المسار

class PrivacyController extends GetxController {
  // متغير تفاعلي للتحكم في التشيك بوكس (مغلق افتراضياً)
  var isAccepted = false.obs;

  // دالة لتغيير حالة التشيك بوكس
  void toggleAcceptance(bool? value) {
    if (value != null) {
      isAccepted.value = value;
    }
  }

  // دالة الاستمرار
  void continueToFilter() {
    if (isAccepted.value) {
      Get.back(); // إغلاق النافذة المنبثقة
      Get.to(() => const LocationFilterScreen()); // الانتقال لواجهة الفلترة
    }
  }

  // دالة إغلاق النافذة (الرجوع)
  void closeDialog() {
    Get.back();
  }
}