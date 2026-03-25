import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitlednew2/core/theme/app_colors.dart';
import 'package:untitlednew2/core/widgets/custom_button.dart';
import 'package:untitlednew2/core/widgets/custom_text_field.dart';
import '../../../../core/theme/ app_text_styles.dart';
import '../../logic/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام Get.put خارج الـ return لضمان ثباته
    final controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('images/aqar.jpeg'), fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 50,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.3),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: Column(
                    children: [
                      Text('تسجيل الدخول', style: AppTextStyles.font24Bold.copyWith(fontSize: 32)),
                      const SizedBox(height: 40),
                      CustomTextField(
                        hintText: 'البريد الإلكتروني',
                        icon: Icons.email,
                        controller: controller.emailController,
                      ),
                      CustomTextField(
                        hintText: 'كلمة السر',
                        icon: Icons.lock,
                        isPassword: true,
                        controller: controller.passwordController,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => controller.navigateToForgotPassword(),
                          child: const Text('نسيت كلمة السر؟', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(text: 'دخول', onPressed: () => controller.handleLogin()),
                      const SizedBox(height: 30),
                      _buildFooter(controller),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(LoginController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => controller.navigateToSelectAccountType(),
          child: const Text('إنشاء حساب جديد', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
        ),
        const Text('ليس لديك حساب؟ ', style: TextStyle(color: AppColors.textDark)),
      ],
    );
  }
}