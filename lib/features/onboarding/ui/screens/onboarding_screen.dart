import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ استيراد GetX
import '../../../../core/theme/ app_text_styles.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../logic/onboarding_controller.dart';// ✅ استيراد الكنترولر
import '../widgets/ animated_house.dart';



class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ حقن الكنترولر في الواجهة
    final OnboardingController controller = Get.put(OnboardingController());

    return Scaffold(
      body: Stack(
        children: [
          // خلفية الاونبوردنغ
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/onboarding.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // التغبيش
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),

          // المحتوى
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const AnimatedHouse(),
                  const SizedBox(height: 50),

                  Text(
                    'مرحباً بك في عالم العقارات',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font24Bold,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'طريقك الأسهل والأسرع للعثور على عقار أحلامك أو استثمارك القادم بكل ثقة.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font14GreyRegular.copyWith(
                      color: AppColors.darkNavy.withOpacity(0.7),
                    ),
                  ),

                  const Spacer(),
                  // ✅ استخدام الكنترولر عند الضغط على الزر
                  CustomButton(
                    text: 'ابدأ الآن',
                    onPressed: () => controller.navigateToHome(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}