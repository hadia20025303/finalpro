import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ إضافة GetX
import 'package:untitlednew2/core/theme/app_colors.dart';
import 'package:untitlednew2/core/widgets/custom_button.dart';
import 'package:untitlednew2/core/widgets/custom_text_field.dart';
import '../../../../core/theme/ app_text_styles.dart';
import '../../logic/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  final String accountType;
  const RegisterScreen({super.key, required this.accountType});

  @override
  Widget build(BuildContext context) {
    // ✅ حقن الكنترولر
    final RegisterController controller = Get.put(RegisterController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            // 1. الصورة الخلفية
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/aqar.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 2. زر الرجوع
            Positioned(
              top: 50,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.3),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () => controller.goBack(),
                ),
              ),
            ),

            // 3. الحاوية البيضاء المنحنية
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.78,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 40,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'إنشاء حساب',
                        style: AppTextStyles.font24Bold.copyWith(fontSize: 30),
                      ),
                      const SizedBox(height: 10),

                      // ✅ مراقبة تغير الخطوات عبر Obx
                      Obx(
                        () => Text(
                          'الخطوة ${controller.currentStep.value} من 2',
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      // ✅ عرض الخطوة بناءً على الحالة
                      Obx(
                        () => controller.currentStep.value == 1
                            ? _buildStepOne(controller)
                            : _buildStepTwo(controller, context),
                      ),

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

  Widget _buildStepOne(RegisterController controller) {
    return Column(
      children: [
        CustomTextField(
          hintText: 'الاسم الكامل',
          icon: Icons.person,
          controller: controller.nameController,
        ),
        CustomTextField(
          hintText: 'البريد الإلكتروني',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          controller: controller.emailController,
        ),
        CustomTextField(
          hintText: 'رقم الهاتف',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          controller: controller.phoneController,
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'التالي',
          onPressed: () => controller.validateAndGoToNext(),
        ),
      ],
    );
  }

  Widget _buildStepTwo(RegisterController controller, BuildContext context) {
    return Column(
      children: [
        if (accountType == 'agent')
          CustomTextField(
            hintText: 'رقم السجل التجاري',
            icon: Icons.assignment_ind,
            controller: controller.commercialIdController,
          ),

        CustomTextField(
          hintText: 'كلمة السر',
          icon: Icons.lock,
          isPassword: true,
          controller: controller.passwordController,
        ),
        CustomTextField(
          hintText: 'تأكيد كلمة السر',
          icon: Icons.lock_outline,
          isPassword: true,
          controller: controller.confirmPasswordController,
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'إنشاء الحساب الآن',
          onPressed: () => controller.handleRegisterFinal(accountType, context),
        ),
        TextButton(
          onPressed: () => controller.currentStep.value = 1,
          child: const Text(
            'العودة للخطوة السابقة',
            style: TextStyle(
              color: AppColors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(RegisterController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'لديك حساب بالفعل؟ ',
          style: TextStyle(color: AppColors.textDark),
        ),
        GestureDetector(
          onTap: () => controller.navigateToLogin(),
          child: const Text(
            'تسجيل دخول',
            style: TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
