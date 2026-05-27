// lib/features/home/ui/screens/home_screen.dart
// ✅ أيقونة القلب تعكس حالة الزائر عبر AuthController

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitlednew2/core/theme/app_colors.dart';
import '../../../../core/controllers/auth_controller.dart';  // ✅
import '../../../../core/theme/ app_text_styles.dart';
import '../../data/models/property_repository.dart';
import '../../logic/home_controller.dart';

import 'services_screen.dart';
import 'properties_screen.dart';
import 'location_filter_screen.dart';
import 'property_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final String? selectedArea;
  const HomeScreen({super.key, this.selectedArea});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    controller.initData(selectedArea);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/aqar.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.72,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  children: [
                    _buildTopTabs(context),
                    const SizedBox(height: 20),
                    _buildFilterSection(context),
                    const SizedBox(height: 25),
                    Obx(
                          () => controller.displayProperties.isEmpty
                          ? const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text("لا توجد عقارات في هذه المنطقة حالياً"),
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.displayProperties.length,
                        itemBuilder: (context, index) {
                          final property = controller.displayProperties[index];
                          return _buildPropertyCard(context, property, controller);
                        },
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),

          Obx(
                () => controller.showBackToTopButton.value
                ? Positioned(
              bottom: 110,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: AppColors.accent,
                onPressed: () => controller.scrollToTop(),
                child: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 30),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(
      BuildContext context,
      dynamic property,
      HomeController controller,
      ) {
    return InkWell(
      onTap: () {
        Get.to(() => PropertyDetailsScreen(property: property))
            ?.then((value) => controller.displayProperties.refresh());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ أيقونة القلب: رمادية للزائر، ملوّنة للمسجّل
                  GestureDetector(
                    onTap: () => controller.toggleFavorite(property.id),
                    child: Obx(() {
                      final bool isLoggedIn = AuthController.to.isLoggedIn.value;
                      return Icon(
                        property.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: !isLoggedIn
                            ? Colors.grey.shade400          // زائر → رمادي
                            : (property.isFavorite
                            ? Colors.red                 // مسجّل + مفضّل
                            : AppColors.accent),         // مسجّل + غير مفضّل
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    property.price,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(property.size,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(property.area,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      property.imageUrl,
                      height: 90,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTabs(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tabButton("العقارات", true, () => Get.to(() => const PropertiesScreen())),
        const SizedBox(width: 15),
        _tabButton("الخدمات", false, () => Get.to(() => const ServicesScreen())),
      ],
    );
  }

  Widget _tabButton(String title, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => const LocationFilterScreen()),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.tune, color: AppColors.accent, size: 24),
              const SizedBox(width: 10),
              Text(
                'فلترة النتائج',
                style: AppTextStyles.font16SemiBold.copyWith(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(width: 80, height: 2, color: AppColors.accent),
        ],
      ),
    );
  }
}
