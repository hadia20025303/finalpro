//هذا الملف سيهتم بعمليات الانتقال من واجهة البداية إلى واجهات الدخول أو اختيار نوع الحساب
import 'package:get/get.dart';
import '../../home/ui/screens/location_filter_screen.dart';
import '../ui/screens/login_screen.dart';
import '../ui/screens/select_account_type_screen.dart';

class GetStartedController extends GetxController {

  // أضف هذه الدالة داخل كلاس GetStartedController في ملف logic
  void navigateToHomeAsGuest() {
    // تصفير حالة الدخول في المستودع (للتأكد أنه زائر)
    // Get.find<UserRepository>().isLoggedIn.value = false;

    // الانتقال مباشرة لواجهة الفلترة ثم الهوم
    Get.offAll(
          () => const LocationFilterScreen(),
      transition: Transition.circularReveal,
      duration: const Duration(seconds: 1),
    );
  }

  // الانتقال لواجهة تسجيل الدخول
  void navigateToLogin() {
    Get.to(
      () => const LoginScreen(),
      transition: Transition.rightToLeftWithFade,
    );
  }

  // الانتقال لواجهة اختيار نوع الحساب
  void navigateToSelectAccountType() {
    Get.to(
      () => const SelectAccountTypeScreen(),
      transition: Transition.leftToRightWithFade,
    );
  }
}
