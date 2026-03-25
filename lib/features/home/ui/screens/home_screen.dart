import 'package:flutter/material.dart';
import 'package:untitlednew2/core/theme/app_colors.dart';

import '../../../../core/theme/ app_text_styles.dart';
import '../../data/models/property_repository.dart';
import 'services_screen.dart';
import 'properties_screen.dart';
import 'location_filter_screen.dart';
import 'property_details_screen.dart'; // ✅ إضافة استيراد واجهة التفاصيل

class HomeScreen extends StatefulWidget {
  final String? selectedArea; // ✅ إضافة استقبال المنطقة المختارة
  const HomeScreen({super.key, this.selectedArea});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PropertyRepository _repo = PropertyRepository();
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;

  // ✅ قائمة العقارات التي سيتم عرضها (بعد الفلترة أو الكل)
  late List<dynamic> _displayProperties;

  @override
  void initState() {
    super.initState();

    // ✅ منطق الفلترة المبدئي:
    // إذا كانت هناك منطقة مختارة، نقوم بتصفية القائمة، وإلا نعرض كل العقارات
    if (widget.selectedArea != null) {
      _displayProperties = _repo.allProperties
          .where((p) => p.area.contains(widget.selectedArea!))
          .toList();
    } else {
      _displayProperties = _repo.allProperties;
    }

    _scrollController.addListener(() {
      if (mounted)
        setState(() => _showBackToTopButton = _scrollController.offset > 300);
    });
  }

  void _toggleFavorite(String id) {
    setState(() {
      _repo.toggleFavorite(id);
    });
    final isFav = _repo.allProperties.firstWhere((p) => p.id == id).isFavorite;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFav ? "تمت الإضافة إلى المفضلة ❤️" : "تمت الإزالة من المفضلة",
          textAlign: TextAlign.right,
        ),
        backgroundColor: isFav ? Colors.green : Colors.redAccent,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Column(
                  children: [
                    _buildTopTabs(),
                    const SizedBox(height: 20),
                    _buildFilterSection(),
                    const SizedBox(height: 25),

                    // ✅ تم تحديث الـ ListView لاستخدام القائمة المفلترة _displayProperties
                    _displayProperties.isEmpty
                        ? const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Text("لا توجد عقارات في هذه المنطقة حالياً"),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _displayProperties.length,
                      itemBuilder: (context, index) {
                        final property = _displayProperties[index];
                        return _buildPropertyCard(property);
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          if (_showBackToTopButton)
            Positioned(
              bottom: 110,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: AppColors.accent,
                onPressed: () => _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                ),
                child: const Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ✅ ربط الانتقال لصفحة التفاصيل
  Widget _buildPropertyCard(dynamic property) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailsScreen(property: property),
          ),
        ).then(
              (value) => setState(() {}),
        );
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
                  GestureDetector(
                    onTap: () => _toggleFavorite(property.id),
                    child: Icon(
                      property.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: property.isFavorite
                          ? Colors.red
                          : AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    property.price,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    property.size,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    property.area,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
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

  Widget _buildTopTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tabButton(
          "العقارات",
          true,
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PropertiesScreen()),
          ),
        ),
        const SizedBox(width: 15),
        _tabButton(
          "الخدمات",
          false,
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ServicesScreen()),
          ),
        ),
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

  Widget _buildFilterSection() {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LocationFilterScreen()),
      ),
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