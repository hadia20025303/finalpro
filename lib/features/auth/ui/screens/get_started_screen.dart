import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ استيراد GetX
import '../../../../core/theme/ app_text_styles.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../logic/get_started_controller.dart';//✅ استيراد الكنترولر


class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ حقن الكنترولر في الواجهة
    final GetStartedController controller = Get.put(GetStartedController());

    return Scaffold(
      body: Stack(
        children: [
          // 1. الصورة الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/getstarted.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. المحتوى
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // النصوص
                  Text(
                    'ادخل بياناتك الشخصية للوصول إلى حسابك\nواكتشاف أفضل العقارات',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font24Bold,
                  ),

                  const Spacer(flex: 2),

                  // 3. الأزرار (بجانب بعضهما)
                  Row(
                    children: [
                      // زر تسجيل الدخول
                      Expanded(
                        child: CustomButton(
                          text: 'تسجيل الدخول',
                          backgroundColor: AppColors.darkNavy,
                          onPressed: () => controller
                              .navigateToLogin(), // ✅ استخدام الكنترولر
                        ),
                      ),
                      const SizedBox(width: 15),

                      // زر إنشاء حساب
                      Expanded(
                        child: CustomButton(
                          text: 'إنشاء حساب',
                          backgroundColor: AppColors.accent,
                          onPressed: () => controller
                              .navigateToSelectAccountType(), // ✅ استخدام الكنترولر
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
