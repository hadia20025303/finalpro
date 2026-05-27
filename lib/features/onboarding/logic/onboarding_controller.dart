import 'package:get/get.dart';
// ✅ استيراد الهيكل الرئيسي لكي يتمكن المستخدم من التصفح مباشرة
import '../../main/ui/screens/main_layout_screen.dart';

class OnboardingController extends GetxController {

  // ✅ دالة الانتقال مباشرة لواجهة التطبيق الرئيسية (التصفح كزائر)
  void navigateToHome() {
    // استخدمنا Get.off لكي لا يتمكن المستخدم من العودة لصفحة الترحيب مرة أخرى
    Get.off(
          () => const MainLayoutScreen(),
      transition: Transition.fadeIn, // أنميشن ناعم واحترافي
      duration: const Duration(milliseconds: 800),
    );
  }
}