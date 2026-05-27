import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/ app_text_styles.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../logic/get_started_controller.dart';


class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الكنترولر المسؤول عن التنقل
    final GetStartedController controller = Get.put(GetStartedController());

    return Scaffold(
      body: Stack(
        children: [
          // 1. الصورة الخلفية (نفس الهوية البصرية)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/getstarted.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. المحتوى الرئيسي
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const Spacer(flex: 3), // دفع النص للمنتصف

                  // النصوص الترحيبية
                  Text(
                    'ادخل بياناتك الشخصية للوصول إلى حسابك\nواكتشاف أفضل العقارات',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font24Bold.copyWith(
                      color: Colors.white, // جعل النص أبيض ليتناسب مع الخلفية
                      shadows: [
                        const Shadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 2))
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // 3. قسم الأزرار
                  Column(
                    children: [
                      Row(
                        children: [
                          // زر تسجيل الدخول
                          Expanded(
                            child: CustomButton(
                              text: 'تسجيل الدخول',
                              backgroundColor: AppColors.darkNavy,
                              onPressed: () => controller.navigateToLogin(),
                            ),
                          ),
                          const SizedBox(width: 15),

                          // زر إنشاء حساب
                          Expanded(
                            child: CustomButton(
                              text: 'إنشاء حساب',
                              backgroundColor: AppColors.accent,
                              onPressed: () => controller.navigateToSelectAccountType(),
                            ),
                          ),
                        ],
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