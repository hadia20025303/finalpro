import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitlednew2/core/utils/app_validator.dart';
import '../ui/screens/login_screen.dart';

class ForgotPasswordController extends GetxController {
  var currentStep = 1.obs;
  var isCodeValid = Rxn<bool>();
  var secondsRemaining = 60.obs;
  Timer? timer;

  final emailController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void startTimer() {
    secondsRemaining.value = 60;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        t.cancel();
      }
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    // ملاحظة: تركنا dispose للمتحكمات لـ Flutter ليتعامل معها عند حذف الشاشة فعلياً
    // لمنع خطأ "used after being disposed"
    super.onClose();
  }

  void sendCode() {
    String? err = AppValidator.validateEmail(emailController.text);
    if (err != null) {
      _showSnack(err);
      return;
    }
    _showSnack("تم إرسال رمز التحقق", isSuccess: true);
    currentStep.value = 2;
    startTimer();
  }

  void verifyCode() {
    String code = otpControllers.map((c) => c.text).join();
    if (code.length < 4) return;
    isCodeValid.value = true;
    Future.delayed(const Duration(milliseconds: 500), () => currentStep.value = 3);
  }

  void resetPassword() {
    // إغلاق الكيبورد فوراً
    FocusManager.instance.primaryFocus?.unfocus();

    // الانتقال لواجهة التحميل أولاً لضمان اختفاء الحقول النصية
    currentStep.value = 4;

    Future.delayed(const Duration(milliseconds: 500), () {
      // نستخدم Get.offAll مع اسم الشاشة لضمان إعادة بناء نظيفة
      // حذف الكنترولر الحالي قبل الانتقال لضمان عدم تعليق الذاكرة
      Get.delete<ForgotPasswordController>();

      // الانتقال النهائي
      Get.offAll(() => const LoginScreen(), transition: Transition.noTransition);
    });
  }

  void _showSnack(String m, {bool isSuccess = false}) {
    Get.snackbar("تنبيه", m, backgroundColor: isSuccess ? Colors.green : Colors.red, colorText: Colors.white);
  }

  void handleBack() => currentStep.value > 1 ? currentStep.value-- : Get.back();
}