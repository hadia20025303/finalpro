// lib/core/controllers/auth_controller.dart
// ✅ كنترولر مركزي لإدارة حالة المستخدم (زائر / مسجّل)

import 'package:get/get.dart';

class AuthController extends GetxController {
  // ────────────────────────────────────────
  // Singleton: نفس النسخة في كل التطبيق
  // ────────────────────────────────────────
  static AuthController get to => Get.find();

  // false = زائر  |  true = مسجّل دخول
  var isLoggedIn = false.obs;
  var userName   = ''.obs;
  var userEmail  = ''.obs;

  bool get isGuest => !isLoggedIn.value;

  // ────────────────────────────────────────
  // تسجيل الدخول (استدعِها بعد نجاح الـ Login)
  // ────────────────────────────────────────
  void login({required String name, required String email}) {
    userName.value  = name;
    userEmail.value = email;
    isLoggedIn.value = true;
  }

  // ────────────────────────────────────────
  // تسجيل الخروج → يعود زائراً
  // ────────────────────────────────────────
  void logout() {
    userName.value   = '';
    userEmail.value  = '';
    isLoggedIn.value = false;
  }
}
