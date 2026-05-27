import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ إضافة GetX
import 'package:untitlednew2/core/theme/app_colors.dart';
import '../../../../core/theme/ app_text_styles.dart';
import '../../../home/ui/screens/property_details_screen.dart';
import '../../logic/favorites_controller.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ حقن الكنترولر
    final FavoritesController controller = Get.put(FavoritesController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            // 1. الخلفية
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('images/aqar.jpeg'), fit: BoxFit.cover),
              ),
            ),

            // 2. الكرت الأبيض والمحتوى
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.72,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                ),
                child: Column(
                  children: [
                    // العنوان الثابت
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 30, 25, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.favorite, color: Colors.red, size: 28),
                          const SizedBox(width: 10),
                          Text('قائمة مفضلاتي', style: AppTextStyles.font24Bold.copyWith(fontSize: 26)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),

                    // ✅ مراقبة العدد
                    Obx(() => Text(
                        'لديك (${controller.favList.length}) عقارات في المفضلة',
                        style: AppTextStyles.font14GreyRegular
                    )),

                    const SizedBox(height: 20),
                    const Divider(indent: 50, endIndent: 50, thickness: 1),

                    // ✅ مراقبة القائمة القابلة للنقر والتمرير
                    Expanded(
                      child: Obx(() => controller.favList.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                        controller: controller.scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemCount: controller.favList.length,
                        itemBuilder: (context, index) {
                          final property = controller.favList[index];
                          return InkWell(
                            onTap: () {
                              // الانتقال عبر Get.to وتحديث المفضلات عند العودة
                              Get.to(() => PropertyDetailsScreen(property: property))
                                  ?.then((value) => controller.loadFavorites());
                            },
                            child: _buildFavoriteCard(property, controller),
                          );
                        },
                      )),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // ✅ مراقبة زر العودة للأعلى
            Obx(() => controller.showBackToTopButton.value
                ? Positioned(
              bottom: 110,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: AppColors.accent,
                onPressed: controller.scrollToTop,
                child: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 30),
              ),
            )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade300),
        const SizedBox(height: 20),
        const Text("المفضلة فارغة حالياً ❤️", style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildFavoriteCard(dynamic property, FavoritesController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red, size: 22),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () => controller.removeFromFavorites(property.id), // ✅ استدعاء الكنترولر
                      child: Icon(Icons.delete_outline, color: Colors.grey.shade400, size: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(property.price, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 15)),
                Text(property.size, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(property.area, style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
                  child: Image.asset(property.imageUrl, height: 85, width: double.infinity, fit: BoxFit.cover),
                ),
                const SizedBox(height: 8),
                Text(
                  property.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}