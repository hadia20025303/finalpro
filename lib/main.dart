import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitlednew2/features/onboarding/ui/screens/onboarding_screen.dart';
import 'core/controllers/auth_controller.dart';        // ✅ جديد ومسجل دائماً
import 'core/theme/app_theme.dart';
import 'features/main/ui/screens/main_layout_screen.dart'; // ✅ يفتح مباشرة
import 'features/profile/data/user_repository.dart';

void main() {
  // لضمان تهيئة إعدادات فلاتر قبل التشغيل
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تسجيل الكنترولرات الأساسية بشكل دائم لضمان استقرار الذاكرة وحفظ البيانات
  Get.put(AuthController(), permanent: true);
  Get.put(UserRepository(), permanent: true);

  runApp(const RealEstateApp());
}

class RealEstateApp extends StatelessWidget {
  const RealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aqar App',
      theme: AppTheme.lightTheme,

      // ضبط اللغة العربية كاتجاه افتراضي (RTL)
      locale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('ar', 'SA'),

      // ✅ التعديل: يفتح مباشرة كزائر على الهوم (بدون Onboarding)
      home: const OnboardingScreen(),
    );
  }
}