import 'package:get/get.dart';
// ✅ استخدام المسار المطلق لضمان التعرف على واجهة التسجيل

import '../ui/screens/register_screen.dart';

class AccountTypeController extends GetxController {

  void selectTypeAndNavigate(String type) {
    Get.to(
          () => RegisterScreen(accountType: type),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 500),
    );
  }

  void goBack() {
    Get.back();
  }
}