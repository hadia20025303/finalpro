import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ إضافة GetX

import 'package:untitlednew2/core/theme/app_colors.dart';
import '../../../../core/theme/ app_text_styles.dart';
import '../../logic/account_type_controller.dart';

class SelectAccountTypeScreen extends StatelessWidget {
  const SelectAccountTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ حقن الكنترولر
    final AccountTypeController controller = Get.put(AccountTypeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            // 1. الصورة الخلفية (التصميم الأصلي)
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/aqar.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 2. زر الرجوع الدائري (التصميم الأصلي)
            Positioned(
              top: 50,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.3),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () => controller.goBack(), // ✅ استخدام الكنترولر
                ),
              ),
            ),

            // 3. الحاوية البيضاء المنحنية (نفس التصميم المعتمد 0.7)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'اختر نوع الحساب',
                      style: AppTextStyles.font24Bold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'يرجى تحديد هويتك للمتابعة في التطبيق',
                      style: TextStyle(color: AppColors.grey, fontSize: 14 ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // استخدام الـ Widget المساعد بنفس ستايلك
                    _buildTypeCard(
                      context,
                      'مستخدم عادي',
                      Icons.person_outline,
                          () => controller.selectTypeAndNavigate('user'),
                    ),
                    const SizedBox(height: 20),
                    _buildTypeCard(
                      context,
                      'وكيل عقاري / شركة',
                      Icons.business_center_outlined,
                          () => controller.selectTypeAndNavigate('agent'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ نفس الـ Widget المساعد الذي صممته أنت يدوياً
  Widget _buildTypeCard(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.accent),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 30),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.font16SemiBold,
                textAlign: TextAlign.right,
              ),
            ),
            const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}