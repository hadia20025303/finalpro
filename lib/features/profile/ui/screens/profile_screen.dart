import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ إضافة GetX
import 'package:image_picker/image_picker.dart';
import 'package:untitlednew2/core/theme/app_colors.dart';
import 'package:untitlednew2/core/widgets/custom_button.dart';
import 'package:untitlednew2/core/widgets/custom_text_field.dart';
import 'package:untitlednew2/features/auth/ui/screens/forgot_password_screen.dart';
import 'package:untitlednew2/features/onboarding/ui/screens/onboarding_screen.dart';

import 'package:untitlednew2/features/main/ui/screens/main_layout_screen.dart'; // ✅ استيراد الهيكل الرئيسي للعودة إليه كزائر

import '../../../../core/theme/ app_text_styles.dart';
import '../../logic/profile_controller.dart';
import 'package:untitlednew2/core/controllers/auth_controller.dart'; // ✅ استيراد AuthController
import 'package:untitlednew2/features/profile/data/user_repository.dart'; // ✅ استيراد UserRepository

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ حقن الكنترولر
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            // الطبقة 1: صورة الخلفية
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/aqar.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // الطبقة 3: الكرت الأبيض المنحني والمحتوى
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
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
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      // صورة الأفاتار (مراقبة عبر Obx)
                      Obx(() => _buildProfileAvatar(controller)),

                      const SizedBox(height: 15),

                      // العنوان مع أيقونة التعديل (مراقب عبر Obx)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 40),
                          Text(
                            'الملف الشخصي',
                            style: AppTextStyles.font24Bold.copyWith(
                              fontSize: 30,
                            ),
                          ),
                          Obx(
                                () => IconButton(
                              icon: Icon(
                                controller.isEditable.value
                                    ? Icons.check_circle
                                    : Icons.edit,
                                color: AppColors.accent,
                              ),
                              onPressed: () => controller.toggleEdit(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // درع الحماية والحقول (مراقبة عبر Obx)
                      Obx(
                            () => AbsorbPointer(
                          absorbing: !controller.isEditable.value,
                          child: Column(
                            children: [
                              CustomTextField(
                                hintText: 'الاسم الكامل',
                                icon: Icons.person_outline,
                                controller: controller.nameController,
                                enabled: controller.isEditable.value,
                              ),
                              CustomTextField(
                                hintText: 'البريد الإلكتروني',
                                icon: Icons.email_outlined,
                                controller: controller.emailController,
                                enabled: controller.isEditable.value,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              CustomTextField(
                                hintText: 'رقم الهاتف',
                                icon: Icons.phone_android,
                                controller: controller.phoneController,
                                enabled: controller.isEditable.value,
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () =>
                              Get.to(() => const ForgotPasswordScreen()),
                          child: const Text(
                            'تغيير كلمة المرور؟',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // زر الحفظ (يظهر فقط عند التعديل)
                      Obx(
                            () => controller.isEditable.value
                            ? CustomButton(
                          text: 'حفظ التغييرات',
                          onPressed: () => controller.handleSave(),
                        )
                            : const SizedBox.shrink(),
                      ),

                      const SizedBox(height: 15),

                      // ✅ زر تسجيل الخروج المطور (يمسح كل الحالات ويعود كزائر)
                      CustomButton(
                        text: 'تسجيل الخروج',
                        backgroundColor: AppColors.primary.withOpacity(0.7),
                        onPressed: () {
                          // 1. تصفير حالة الدخول في الـ AuthController
                          AuthController.to.logout();

                          // 2. تصفير البيانات داخل الـ UserRepository لكي لا تعلق في الذاكرة
                          Get.find<UserRepository>().clearUserData();

                          // 3. العودة للهيكل الرئيسي كزائر نظيف ومجمد الحساب
                          Get.offAll(() => const MainLayoutScreen());
                        },
                      ),
                      const SizedBox(height: 70),
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

  Widget _buildProfileAvatar(ProfileController controller) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: AppColors.background, width: 5),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFFFD1E8),
            backgroundImage: controller.tempImageFile.value != null
                ? FileImage(controller.tempImageFile.value!)
                : null,
            child: controller.tempImageFile.value == null
                ? const Icon(Icons.person, size: 80, color: Colors.grey)
                : null,
          ),
        ),
        if (controller.isEditable.value)
          Positioned(
            bottom: 5,
            left: 5,
            child: PopupMenuButton<int>(
              offset: const Offset(0, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onSelected: (value) => value == 1
                  ? controller.pickImage(ImageSource.camera)
                  : controller.pickImage(ImageSource.gallery),
              child: CircleAvatar(
                backgroundColor: AppColors.accent,
                radius: 18,
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              itemBuilder: (context) => [
                _buildPopupOption(1, Icons.camera_alt_outlined, 'التقاط صورة'),
                _buildPopupOption(2, Icons.photo_library_outlined, 'من المعرض'),
              ],
            ),
          ),
      ],
    );
  }

  PopupMenuItem<int> _buildPopupOption(int value, IconData icon, String text) {
    return PopupMenuItem(
      value: value,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 22),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.darkNavy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}