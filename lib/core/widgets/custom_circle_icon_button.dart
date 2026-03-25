import 'package:flutter/material.dart';

class CustomCircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const CustomCircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22, // الحجم المناسب للدوائر العلوية
      backgroundColor: Colors.black.withOpacity(0.3), // نفس التعتيم المطلوب
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: 22),
        onPressed: onTap,
      ),
    );
  }
}
