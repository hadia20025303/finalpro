import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ إضافة GetX
import '../theme/app_colors.dart';
// ✅ استيراد الـ AuthController لمعرفة حالة الدخول بصرياً
import '../controllers/auth_controller.dart';

class MainBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onAddTap; // إضافة عقار جديد

  const MainBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ فحص حالة الدخول الحالية
    final bool isLoggedIn = AuthController.to.isLoggedIn.value;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.person_outline, 3, isLoggedIn), // الملف الشخصي
          _buildNavItem(Icons.chat_bubble_outline, 2, isLoggedIn), // الدردشة

          // ✅ زر الزائد (+) في المنتصف (يتحول للرمادي إذا كان زائر)
          GestureDetector(
            onTap: onAddTap,
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // تلوين الحدود بالذهبي للمسجل، وبالرمادي للزائر
                border: Border.all(
                  color: isLoggedIn ? AppColors.accent : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.add,
                // تلوين الزائد بالذهبي للمسجل، وبالرمادي للزائر
                color: isLoggedIn ? AppColors.accent : Colors.grey.shade300,
                size: 30,
              ),
            ),
          ),

          _buildNavItem(Icons.favorite_border, 1, isLoggedIn), // المفضلة
          _buildNavItem(Icons.home_outlined, 0, isLoggedIn), // الرئيسية
        ],
      ),
    );
  }

  // ✅ أضفنا متغير isLoggedIn للدالة لتحديد الألوان بدقة
  Widget _buildNavItem(IconData icon, int index, bool isLoggedIn) {
    bool isSelected = currentIndex == index;

    Color iconColor;

    // إذا كان التبويب ليس "الرئيسية" (index 0) والمستخدم زائر ⬅️ اجعل اللون رمادي باهت
    if (index != 0 && !isLoggedIn) {
      iconColor = Colors.grey.shade300; // مجمد للزوار
    } else {
      // الألوان الطبيعية للمسجلين
      iconColor = isSelected ? AppColors.accent : Colors.grey.shade400;
    }

    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
          const SizedBox(height: 4),
          // النقطة تحت الأيقونة النشطة (تظهر فقط إذا كان مسجلاً ومختاراً للتبويب)
          if (isSelected && (index == 0 || isLoggedIn))
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}