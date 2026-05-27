import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ إضافة GetX
import 'package:untitlednew2/core/theme/app_colors.dart';
import 'package:untitlednew2/core/widgets/custom_button.dart';
import '../../../../core/theme/ app_text_styles.dart';

// استيراد الكنترولر الذي أنشأناه
import '../../logic/privacy_controller.dart';


class PrivacyDialog extends StatelessWidget {
  const PrivacyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ حقن الكنترولر
    final PrivacyController controller = Get.put(PrivacyController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // لتأخذ النافذة حجم المحتوى فقط
            children: [
              // الهيدر: عنوان مع زر إغلاق (للرجوع)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'سياسة الخصوصية',
                    style: AppTextStyles.font16SemiBold,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => controller.closeDialog(), // ✅ استخدام Get.back
                  ),
                ],
              ),
              const Divider(),

              const SizedBox(height: 15),

              // منطقة النص (قابلة للتمرير داخل النافذة)
              Flexible(
                child: Container(
                  height: 250, // تحديد أقصى ارتفاع للنص داخل النافذة
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const SingleChildScrollView(
                    child: Text(
                      "باستخدامك لتطبيق عقار، فإنك توافق على سياسة الخصوصية وشروط الاستخدام. نحن نلتزم بحماية بياناتك الشخصية وضمان سرية المعلومات المتعلقة بالعقارات المعروضة. يمنع استخدام التطبيق لأغراض غير قانونية أو نشر محتوى مضلل.",
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.6,
                        color: AppColors.darkNavy,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // مربع الموافقة (مغلف بـ Obx لمراقبة التغيرات)
              Row(
                children: [
                  Obx(() => Checkbox(
                    value: controller.isAccepted.value,
                    activeColor: AppColors.accent,
                    onChanged: (val) => controller.toggleAcceptance(val), // ✅ تحديث الحالة
                  )),
                  const Expanded(
                    child: Text(
                      'أوافق على كافة الشروط والأحكام',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // زر المتابعة (يتغير لونه وحالته بناءً على Obx)
              Obx(() => CustomButton(
                text: 'استمرار',
                backgroundColor: controller.isAccepted.value ? AppColors.primary : Colors.grey,
                onPressed: controller.isAccepted.value
                    ? () => controller.continueToFilter() // ✅ ينفذ الانتقال
                    : null, // الزر معطل إذا لم يوافق
              )),
            ],
          ),
        ),
      ),
    );
  }
}