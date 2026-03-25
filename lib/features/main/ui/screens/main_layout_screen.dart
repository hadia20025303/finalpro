import 'package:flutter/material.dart';
import 'package:untitlednew2/core/theme/app_colors.dart';
import 'package:untitlednew2/core/widgets/main_bottom_navbar.dart';

// استيراد الشاشات
import '../../../chat/ui/screens/chat_screen.dart';
import '../../../favorites/ui/screens/favorites_screen.dart';
import '../../../home/ui/screens/add_property_screen.dart';
import '../../../home/ui/screens/home_screen.dart';
import '../../../notifications/ui/screen/notifications_screen.dart';
import '../../../profile/ui/screens/profile_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  final String? initialArea; // ✅ أضفنا هذا المتغير لاستلام المنطقة من الفلترة
  const MainLayoutScreen({super.key, this.initialArea}); // ✅ تحديث الـ Constructor

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0; // 0: الرئيسية، 1: المفضلة، 2: الدردشة، 3: البروفايل

  @override
  Widget build(BuildContext context) {
    // ✅ نقلنا القائمة إلى داخل الـ build لنتمكن من الوصول لـ widget.initialArea
    final List<Widget> _screens = [
      HomeScreen(selectedArea: widget.initialArea), // ✅ تمرير المنطقة للهوم
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
            // 1. محتوى الصفحة الحالية (داخل الكرت الأبيض والمنحنيات)
            _screens[_currentIndex],

            // ✅ 2. زر الرجوع الذكي (يختفي في الهوم ويظهر في البقية)
            if (_currentIndex != 0) // الشرط: يظهر فقط إذا لم نكن في الرئيسية
              Positioned(
                top: 50,
                right: 20,
                child: _buildCircleButton(
                  icon: Icons.arrow_forward,
                  onTap: () {
                    setState(() => _currentIndex = 0); // العودة دائماً للهوم
                  },
                ),
              ),

            // 3. زر الإشعارات الثابت (يبقى ظاهراً في كل التبويبات)
            Positioned(
              top: 50,
              left: 20,
              child: _buildCircleButton(
                icon: Icons.notifications_none,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                  );
                },
              ),
            ),
          ],
        ),

        // البار السفلي المعتمد (زر + مدمج بمسافات دقيقة)
        bottomNavigationBar: MainBottomNavbar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          onAddTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddPropertyScreen()),
            );
          },
        ),
      ),
    );
  }

  // ويدجيت الزر الدائري (نفس تصميم الـ Auth المعتمد)
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