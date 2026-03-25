import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitlednew2/core/theme/app_colors.dart';
import 'package:untitlednew2/core/widgets/custom_button.dart';
import 'package:untitlednew2/core/widgets/custom_text_field.dart';
import '../../../../core/theme/ app_text_styles.dart';
import '../../logic/forgot_password_controller.dart';

// نستخدم GetView للوصول للكنترولر بطريقة احترافية ونظيفة
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // نقوم بحقن الكنترولر هنا ولكن خارج دالة الـ build الخاصة بالـ Widgets
    // أو يفضل استدعاؤه بـ Get.put قبل الدخول لهذه الشاشة.
    // للحل السريع والمستقر، نضعه هنا مع التأكد أنه لن يُعاد إنشاؤه.
    final controller = Get.put(ForgotPasswordController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
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
                  onPressed: () => controller.handleBack(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.78,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                ),
                child: Obx(() {
                  // حماية: إذا تم تدمير الكنترولر لا تحاول رسم المحتوى
                  if (Get.isRegistered<ForgotPasswordController>() == false) return const SizedBox();

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: SingleChildScrollView(
                      key: ValueKey<int>(controller.currentStep.value),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                      child: Column(
                        children: [
                          Text('استعادة الحساب', style: AppTextStyles.font24Bold.copyWith(fontSize: 30)),
                          const SizedBox(height: 10),
                          Text(
                            controller.currentStep.value == 1 ? "أدخل بريدك الإلكتروني لإرسال الرمز" :
                            controller.currentStep.value == 2 ? "أدخل الرمز المكون من 4 أرقام" :
                            controller.currentStep.value == 3 ? "قم بتعيين كلمة السر الجديدة" :
                            "جاري تحديث البيانات...",
                            style: AppTextStyles.font14GreyRegular,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 35),
                          if (controller.currentStep.value == 1) _buildStepEmail(controller),
                          if (controller.currentStep.value == 2) _buildStepCode(controller, context),
                          if (controller.currentStep.value == 3) _buildStepNewPassword(controller),
                          if (controller.currentStep.value == 4)
                            const SizedBox(height: 200, child: Center(child: CircularProgressIndicator(color: AppColors.accent))),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepEmail(ForgotPasswordController controller) {
    return Column(
      children: [
        CustomTextField(hintText: 'البريد الإلكتروني', icon: Icons.email, controller: controller.emailController),
        const SizedBox(height: 20),
        CustomButton(text: 'إرسال الرمز', onPressed: controller.sendCode),
      ],
    );
  }

  Widget _buildStepCode(ForgotPasswordController controller, BuildContext context) {
    return Column(
      children: [
        Text("تم إرسال الكود إلى\n${controller.emailController.text}", textAlign: TextAlign.center),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          textDirection: TextDirection.ltr,
          children: List.generate(4, (index) => _buildOTPBox(index, controller, context)),
        ),
        const SizedBox(height: 30),
        CustomButton(text: 'تحقق من الرمز', onPressed: controller.verifyCode),
        const SizedBox(height: 15),
        Obx(() => Text(
          controller.secondsRemaining.value > 0 ? "إعادة الإرسال خلال ${controller.secondsRemaining.value} ثانية" : "",
          style: const TextStyle(color: AppColors.grey),
        )),
        Obx(() => controller.secondsRemaining.value == 0
            ? TextButton(
          onPressed: controller.sendCode,
          child: const Text("إعادة إرسال الرمز الآن", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
        )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildOTPBox(int index, ForgotPasswordController controller, BuildContext context) {
    return SizedBox(
      width: 65,
      height: 75,
      child: Obx(() {
        Color borderColor = controller.isCodeValid.value == null
            ? AppColors.accent
            : (controller.isCodeValid.value! ? Colors.green : Colors.red);

        return TextField(
          controller: controller.otpControllers[index],
          focusNode: controller.focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            counterText: "",
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: borderColor, width: 2)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: borderColor, width: 2.5)),
          ),
          onChanged: (value) {
            if (value.length == 1 && index < 3) {
              FocusScope.of(context).requestFocus(controller.focusNodes[index + 1]);
            }
            if (value.isEmpty && index > 0) {
              FocusScope.of(context).requestFocus(controller.focusNodes[index - 1]);
            }
          },
        );
      }),
    );
  }

  Widget _buildStepNewPassword(ForgotPasswordController controller) {
    return Column(
      children: [
        CustomTextField(hintText: 'كلمة السر الجديدة', icon: Icons.lock, isPassword: true, controller: controller.passwordController),
        CustomTextField(hintText: 'تأكيد كلمة السر', icon: Icons.lock_outline, isPassword: true, controller: controller.confirmPasswordController),
        const SizedBox(height: 25),
        CustomButton(text: 'تغيير كلمة المرور', onPressed: controller.resetPassword),
      ],
    );
  }
}