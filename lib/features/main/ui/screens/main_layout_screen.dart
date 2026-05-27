import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ إضافة GetX
import 'package:untitlednew2/core/theme/app_colors.dart';
import 'package:untitlednew2/core/widgets/main_bottom_navbar.dart';

// استيراد الشاشات
import '../../../chat/ui/screens/chat_screen.dart';
import '../../../favorites/ui/screens/favorites_screen.dart';
import '../../../home/ui/screens/add_property_screen.dart';
import '../../../home/ui/screens/home_screen.dart';
import '../../../notifications/ui/screen/notifications_screen.dart';
import '../../../profile/ui/screens/profile_screen.dart';
// استيراد الكنترولر
import '../../logic/main_layout_controller.dart';


class MainLayoutScreen extends StatelessWidget {
  final String? initialArea;
  const MainLayoutScreen({super.key, this.initialArea});

  @override
  Widget build(BuildContext context) {
    // ✅ حقن الكنترولر الخاص بالهيكل
    final MainLayoutController controller = Get.put(MainLayoutController());

    // القائمة التي تحتوي على الشاشات
    final List<Widget> _screens = [
      HomeScreen(selectedArea: initialArea),
      const FavoritesScreen(),
      const ChatScreen(),
      const ProfileScreen(),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            // 1. محتوى الصفحة الحالية (مراقب عبر Obx)
            Obx(() => _screens[controller.currentIndex.value]),

            // ✅ 2. زر الرجوع الذكي (يظهر فقط إذا لم نكن في الرئيسية)
            Obx(() => controller.currentIndex.value != 0
                ? Positioned(
              top: 50,
              right: 20,
              child: _buildCircleButton(
                icon: Icons.arrow_forward,
                onTap: () => controller.backToHome(), // العودة للهوم
              ),
            )
                : const SizedBox.shrink()),

            // 3. زر الإشعارات الثابت
            Positioned(
              top: 50,
              left: 20,
              child: _buildCircleButton(
                icon: Icons.notifications_none,
                onTap: () => controller.navigateToNotifications(),
              ),
            ),
          ],
        ),

        // البار السفلي المعتمد (مراقب عبر Obx)
        bottomNavigationBar: Obx(() => MainBottomNavbar(
          currentIndex: controller.currentIndex.value,
          onTap: (index) => controller.changeTab(index),
          onAddTap: () => controller.navigateToAddProperty(),
        )),
      ),
    );
  }

  // ويدجيت الزر الدائري (نفس تصميمك المعتمد)
  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.black.withOpacity(0.3),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}