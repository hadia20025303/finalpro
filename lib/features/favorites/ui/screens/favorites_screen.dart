import 'package:flutter/material.dart';
import 'package:untitlednew2/core/theme/app_colors.dart';
import '../../../../core/theme/ app_text_styles.dart';
import '../../../home/data/models/property_repository.dart';
import '../../../home/ui/screens/property_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final PropertyRepository _repo = PropertyRepository();
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 200) {
        if (!_showBackToTopButton) setState(() => _showBackToTopButton = true);
      } else {
        if (_showBackToTopButton) setState(() => _showBackToTopButton = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
  }

  void _removeFromFavorites(String id) {
    setState(() {
      _repo.toggleFavorite(id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("تمت إزالة العقار من المفضلة", textAlign: TextAlign.right),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // جلب قائمة المفضلات الحالية من المخزن
    final favList = _repo.getFavoriteProperties();

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
                    Text('لديك (${favList.length}) عقارات في المفضلة', style: AppTextStyles.font14GreyRegular),
                    const SizedBox(height: 20),
                    const Divider(indent: 50, endIndent: 50, thickness: 1),

                    // القائمة القابلة للنقر والتمرير
                    Expanded(
                      child: favList.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemCount: favList.length,
                        itemBuilder: (context, index) {
                          final property = favList[index];
                          // ✅ إضافة InkWell لجعل المنشور قابلاً للنقر
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PropertyDetailsScreen(property: property),
                                ),
                              ).then((value) {
                                // ✅ تحديث الصفحة عند العودة لضمان اختفاء العقار إذا أزاله المستخدم من "التفاصيل"
                                setState(() {});
                              });
                            },
                            child: _buildFavoriteCard(property),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // زر العودة للأعلى
            if (_showBackToTopButton)
              Positioned(
                bottom: 110,
                right: 20,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: AppColors.accent,
                  onPressed: _scrollToTop,
                  child: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 30),
                ),
              ),
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

  Widget _buildFavoriteCard(dynamic property) {
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
                      onTap: () => _removeFromFavorites(property.id),
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