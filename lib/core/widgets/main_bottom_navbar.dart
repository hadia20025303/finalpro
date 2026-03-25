import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

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
          _buildNavItem(Icons.person_outline, 3), // الملف الشخصي
          _buildNavItem(Icons.chat_bubble_outline, 2), // الدردشة

          // ✅ زر الزائد (+) في المنتصف تماماً كما في الصورة
          GestureDetector(
            onTap: onAddTap,
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent, width: 2),
              ),
              child: const Icon(Icons.add, color: AppColors.accent, size: 30),
            ),
          ),

          _buildNavItem(Icons.favorite_border, 1), // المفضلة
          _buildNavItem(Icons.home_outlined, 0), // الرئيسية
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = currentIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.accent : Colors.grey.shade400,
            size: 28,
          ),
          const SizedBox(height: 4),
          // الخط الصغير أو النقطة تحت الأيقونة النشطة
          if (isSelected)
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