//هذا الملف هو المسؤول عن قرار الانتقال للشاشة التالية
import 'package:get/get.dart';
import '../../auth/ui/screens/get_started_screen.dart';

class OnboardingController extends GetxController {

  // دالة الانتقال لواجهة البداية
  void navigateToGetStarted() {
    // Get.off تعمل مثل Navigator.pushReplacement (تحذف الصفحة الحالية من الذاكرة)
    Get.off(() => const GetStartedScreen(),
        transition: Transition.fadeIn, // إضافة أنميشن ناعم عند الانتقال
        duration: const Duration(milliseconds: 800));
  }
}