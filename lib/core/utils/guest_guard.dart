// lib/core/utils/guest_guard.dart
// ✅ الحارس المركزي: استدعِه قبل أي تفاعل محظور على الزائر

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../theme/app_colors.dart';
import '../../features/auth/ui/screens/get_started_screen.dart';

/// غلّف أي تفاعل محظور بهذه الدالة:
///   onTap: () => guardAction(() => doSomething()),
///
/// • إذا كان المستخدم مسجّلاً  → يُنفَّذ [action] مباشرة
/// • إذا كان زائراً             → يظهر Dialog تسجيل الدخول
void guardAction(VoidCallback action) {
  final auth = Get.find<AuthController>();
  if (auth.isLoggedIn.value) {
    action();
  } else {
    _showLoginDialog();
  }
}

// ─────────────────────────────────────────────────
// Dialog تسجيل الدخول (يظهر عند أي تفاعل محظور)
// ─────────────────────────────────────────────────
void _showLoginDialog() {
  Get.dialog(
    Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── أيقونة ──────────────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
              const SizedBox(height: 18),

              // ── العنوان ──────────────────────────────
              const Text(
                'تسجيل الدخول مطلوب',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNavy,
                ),
              ),
              const SizedBox(height: 10),

              // ── الوصف ────────────────────────────────
              const Text(
                'يجب تسجيل الدخول للاستفادة من هذه الميزة.\nسجّل دخولك أو أنشئ حساباً جديداً.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 28),

              // ── زر تسجيل الدخول ──────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Get.back(); // أغلق الـ Dialog
                    Get.to(() => const GetStartedScreen());
                  },
                  child: const Text(
                    'تسجيل الدخول / إنشاء حساب',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // ── زر الإلغاء ───────────────────────────
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'ليس الآن',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
