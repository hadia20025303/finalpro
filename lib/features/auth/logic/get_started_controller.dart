//هذا الملف سيهتم بعمليات الانتقال من واجهة البداية إلى واجهات الدخول أو اختيار نوع الحساب
import 'package:get/get.dart';
import '../ui/screens/login_screen.dart';
import '../ui/screens/select_account_type_screen.dart';

class GetStartedController extends GetxController {
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
