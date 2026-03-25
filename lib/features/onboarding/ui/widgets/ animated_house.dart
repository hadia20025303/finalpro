import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AnimatedHouse extends StatefulWidget {
  const AnimatedHouse({super.key});

  @override
  State<AnimatedHouse> createState() => _AnimatedHouseState();
}

class _AnimatedHouseState extends State<AnimatedHouse> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // تجعل الحركة مستمرة ذهاباً وإياباً

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.1), // يتحرك للأعلى قليلاً
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            )
          ],
        ),
        child: const Icon(
          Icons.home_work_rounded, // أيقونة منزل احترافية
          size: 100,
          color: AppColors.accent, // اللون الذهبي البرونزي
        ),
      ),
    );
  }
}