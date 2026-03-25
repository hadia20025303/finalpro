import 'package:flutter/material.dart';
import 'package:untitlednew2/core/theme/app_colors.dart';

import '../../data/models/property_model.dart';
import '../../data/models/property_repository.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final PropertyModel property;

  const PropertyDetailsScreen({super.key, required this.property});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  final PropertyRepository _repo = PropertyRepository();

  // دالة التبديل للمفضلة مع تحديث الواجهة
  void _toggleFavorite() {
    setState(() {
      _repo.toggleFavorite(widget.property.id);
    });
    bool isFav = widget.property.isFavorite;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFav ? "تمت الإضافة للمفضلة ❤️" : "تمت الإزالة من المفضلة",
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
      backgroundColor: AppColors.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // --- القسم العلوي (الصورة والأيقونات) ---
            _buildImageHeader(context),

            // باقي التفاصيل (سنكملها لاحقاً حسب طلبك)
            const Expanded(
              child: Center(
                child: Text(
                  "باقي تفاصيل العقار ستظهر هنا...",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ ويدجيت الصورة المركزية مع الأيقونات العلوية
  Widget _buildImageHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Stack(
        children: [
          // 1. الصورة في المنتصف مع مسافات (Margins)
          Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(widget.property.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),

          // 2. زر الرجوع (أعلى اليمين فوق الصورة)
          Positioned(
            top: 15,
            right: 15,
            child: _buildHeaderIcon(
              Icons.arrow_forward,
              () => Navigator.pop(context),
            ),
          ),

          // 3. أيقونات التحكم (أعلى اليسار فوق الصورة)
          Positioned(
            top: 15,
            left: 15,
            child: Row(
              children: [
                // زر سلة المحذوفات (للحذف من المفضلة)
                _buildHeaderIcon(
                  Icons.delete_outline,
                  widget.property.isFavorite ? _toggleFavorite : () {},
                  color: widget.property.isFavorite ? Colors.red : Colors.grey,
                ),
                const SizedBox(width: 10),
                // زر القلب
                _buildHeaderIcon(
                  widget.property.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  _toggleFavorite,
                  color: widget.property.isFavorite ? Colors.red : Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ويدجيت مساعد لبناء الأزرار الدائرية فوق الصورة
  Widget _buildHeaderIcon(
    IconData icon,
    VoidCallback onTap, {
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.black.withOpacity(0.3),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
