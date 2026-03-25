import 'package:flutter/material.dart';
import 'package:untitlednew2/core/theme/app_colors.dart';

import 'package:untitlednew2/core/widgets/custom_button.dart';
// استورد واجهة الفلترة هنا لاحقاً
// import '../../home/ui/screens/filter_screen.dart';
import '../../../../core/theme/ app_text_styles.dart';
import '../../../home/ui/screens/location_filter_screen.dart';

class PrivacyDialog extends StatefulWidget {
  const PrivacyDialog({super.key});

  @override
  State<PrivacyDialog> createState() => _PrivacyDialogState();
}

class _PrivacyDialogState extends State<PrivacyDialog> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () =>
                        Navigator.pop(context), // العودة للخطوة السابقة
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

              // مربع الموافقة
              Row(
                children: [
                  Checkbox(
                    value: _isAccepted,
                    activeColor: AppColors.accent,
                    onChanged: (val) {
                      setState(() => _isAccepted = val!);
                    },
                  ),
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

              // زر المتابعة
              CustomButton(
                text: 'استمرار',
                backgroundColor: _isAccepted ? AppColors.primary : Colors.grey,
                onPressed: _isAccepted
                    ? () {
                        Navigator.pop(context); // إغلاق النافذة
                        // ✅ الانتقال لواجهة الفلترة (التي سأرسلها لك)
                       // print("الانتقال لواجهة الفلترة...");
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => const FilterScreen()));
                        Navigator.pop(context); // إغلاق النافذة
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LocationFilterScreen())
                        );
                      }
                    : null, // الزر معطل إذا لم يوافق
              ),
            ],
          ),
        ),
      ),
    );
  }
}
