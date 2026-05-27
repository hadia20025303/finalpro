import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitlednew2/core/utils/app_validator.dart';
// ✅ 1. استيراد الـ AuthController الجديد بدلاً من UserRepository
import 'package:untitlednew2/core/controllers/auth_controller.dart';
import '../ui/screens/forgot_password_screen.dart';
import '../ui/screens/select_account_type_screen.dart';
import '../ui/widgets/privacy_dialog.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onClose() {
    super.onClose();
  }

  void handleLogin() {
    // 1. التحقق من صحة المدخلات
    String? emailError = AppValidator.validateEmail(emailController.text);
    String? passwordError = AppValidator.validatePassword(passwordController.text);

    if (emailError != null || passwordError != null) {
      Get.snackbar(
          "تنبيه",
          emailError ?? passwordError!,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white
      );
      return;
    }

    // ✅ 2. التعديل المطلوب: استدعاء الـ login من AuthController لتفعيل الحساب
    // قمنا بتمرير الإيميل المكتوب، واسم افتراضي (هادية عبد) مؤقتاً لحين ربط الباك إيند
    AuthController.to.login(
      name: "هادية عبد",
      email: emailController.text.trim(),
    );

    // 3. إظهار نافذة الخصوصية للانتقال للخطوة التالية
    Get.dialog(const PrivacyDialog(), barrierDismissible: false);
  }

  void navigateToForgotPassword() => Get.to(() => const ForgotPasswordScreen());
  void navigateToSelectAccountType() => Get.to(() => const SelectAccountTypeScreen());
}