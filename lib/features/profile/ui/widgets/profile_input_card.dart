import 'package:flutter/material.dart';
import 'package:untitlednew2/core/theme/app_colors.dart';

class ProfileInputCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool enabled; // ✅ أضفنا هذه الخاصية للتحكم عبر GetX

  const ProfileInputCard({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.enabled = true, // ✅ القيمة الافتراضية هي مفعل
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ✅ تغيير لون الأيقونة بناءً على حالة التفعيل
          Icon(
              icon,
              color: enabled ? AppColors.accent : Colors.grey.shade400,
              size: 22
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: AppColors.grey),
                ),
                TextField(
                  controller: controller,
                  enabled: enabled, // ✅ ربط خاصية التفعيل بالـ TextField
                  keyboardType: keyboardType,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // ✅ تغيير لون النص عند القفل ليعطي انطباع الـ Read-only
                    color: enabled ? AppColors.darkNavy : Colors.grey,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}