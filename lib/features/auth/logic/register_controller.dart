import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitlednew2/core/utils/app_validator.dart';
// ✅ 1. استيراد الـ AuthController الجديد بدلاً من UserRepository
import 'package:untitlednew2/core/controllers/auth_controller.dart';
import '../ui/widgets/privacy_dialog.dart';
import '../ui/screens/login_screen.dart';

class RegisterController extends GetxController {
  // ✅ متغير تفاعلي للتحكم في الخطوات
  var currentStep = 1.obs;

  // ✅ تعريف المتحكمات (نفس الأسماء لضمان عدم الخطأ)
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final commercialIdController = TextEditingController();

  @override
  void onClose() {
    // تنظيف الذاكرة
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    commercialIdController.dispose();
    super.onClose();
  }

  // دالة عرض الأخطاء (نفس منطقك السابق)
  void showSnackBar(String message) {
    Get.snackbar(
      "تنبيه",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(15),
      duration: const Duration(seconds: 2),
    );
  }

  // دالة التحقق من الخطوة الأولى
  void validateAndGoToNext() {
    String? nameErr = AppValidator.validateName(nameController.text);
    String? emailErr = AppValidator.validateEmail(emailController.text);
    String? phoneErr = AppValidator.validatePhone(phoneController.text);

    if (nameErr != null) {
      showSnackBar(nameErr);
      return;
    }
    if (emailErr != null) {
      showSnackBar(emailErr);
      return;
    }
    if (phoneErr != null) {
      showSnackBar(phoneErr);
      return;
    }

    currentStep.value = 2; // الانتقال للخطوة الثانية
  }

  // دالة التسجيل النهائي
  void handleRegisterFinal(String accountType, BuildContext context) {
    if (accountType == 'agent') {
      String? commErr = AppValidator.validateCommercialId(
        commercialIdController.text,
      );
      if (commErr != null) {
        showSnackBar(commErr);
        return;
      }
    }

    String? passErr = AppValidator.validatePassword(passwordController.text);
    String? confirmErr = AppValidator.validateConfirmPassword(
      passwordController.text,
      confirmPasswordController.text,
    );

    if (passErr != null) {
      showSnackBar(passErr);
      return;
    }
    if (confirmErr != null) {
      showSnackBar(confirmErr);
      return;
    }

    // ✅ 2. التعديل المطلوب: استدعاء الـ login من AuthController لتفعيل الحساب الجديد
    // قمنا بأخذ الاسم والإيميل اللذين كتبهما المستخدم في الحقول وتخزينهما في النظام فوراً
    AuthController.to.login(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
    );

    // رسالة النجاح
    Get.snackbar(
      "نجاح",
      "جاري إنشاء الحساب بنجاح...",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // إظهار نافذة الخصوصية (نفس منطقك الأصلي)
    Get.dialog(const PrivacyDialog(), barrierDismissible: false);
  }

  void goBack() {
    if (currentStep.value == 2) {
      currentStep.value = 1;
    } else {
      Get.back();
    }
  }

  void navigateToLogin() => Get.to(() => const LoginScreen());
}