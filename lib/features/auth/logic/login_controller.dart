import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitlednew2/core/utils/app_validator.dart';
import '../ui/screens/forgot_password_screen.dart';
import '../ui/screens/select_account_type_screen.dart';
import '../ui/widgets/privacy_dialog.dart';

class LoginController extends GetxController {
  // لا تستخدم late هنا، قم بالتعريف المباشر
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onClose() {
    // حذفنا الـ dispose اليدوي للمتحكمات النصية لأنها تسبب الخطأ عند الانتقال السريع
    super.onClose();
  }

  void handleLogin() {
    String? emailError = AppValidator.validateEmail(emailController.text);
    String? passwordError = AppValidator.validatePassword(passwordController.text);

    if (emailError != null || passwordError != null) {
      Get.snackbar("تنبيه", emailError ?? passwordError!,
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    Get.dialog(const PrivacyDialog(), barrierDismissible: false);
  }

  void navigateToForgotPassword() => Get.to(() => const ForgotPasswordScreen());
  void navigateToSelectAccountType() => Get.to(() => const SelectAccountTypeScreen());
}