import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ إضافة مكتبة GetX
import 'package:untitlednew2/features/onboarding/ui/screens/onboarding_screen.dart';
import 'core/theme/app_theme.dart';
import 'features/profile/data/user_repository.dart';

void main() {
  Get.put(UserRepository(), permanent: true);
  runApp(const RealEstateApp());
}

class RealEstateApp extends StatelessWidget {
  const RealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ تحويل MaterialApp إلى GetMaterialApp لتمكين ميزات GetX
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aqar App',
      theme: AppTheme.lightTheme,

      // ✅ ضبط اللغة العربية والاتجاه (RTL) كإعداد افتراضي لكل التطبيق
      locale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('ar', 'SA'),

      // البداية من واجهة الترحيب
      home: const OnboardingScreen(),
    );
  }
}
