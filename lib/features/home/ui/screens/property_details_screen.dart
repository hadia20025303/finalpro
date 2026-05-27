import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitlednew2/core/theme/app_colors.dart';
import '../../../../core/utils/guest_guard.dart';              // ✅ جديد: حماية الزائر
import '../../../../core/controllers/auth_controller.dart';    // ✅ جديد: معرفة حالة الدخول
import '../../data/models/property_model.dart';
import '../../logic/property_details_controller.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final PropertyModel property;

  const PropertyDetailsScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final PropertyDetailsController controller = Get.put(PropertyDetailsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // --- القسم العلوي (الصورة والأيقونات) ---
            _buildImageHeader(context, controller),

            // باقي التفاصيل
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

  // ✅ ويدجيت الصورة مع الأيقونات المحمية
  Widget _buildImageHeader(BuildContext context, PropertyDetailsController controller) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Stack(
        children: [
          // 1. الصورة
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
                child: Image.asset(property.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),

          // 2. زر الرجوع (بدون حماية - مسموح للجميع)
          Positioned(
            top: 15,
            right: 15,
            child: _buildHeaderIcon(
              Icons.arrow_forward,
                  () => controller.goBack(),
            ),
          ),

          // 3. أيقونات التحكم (محمية للزائرين)
          Positioned(
            top: 15,
            left: 15,
            child: GetBuilder<PropertyDetailsController>(
              builder: (_) => Row(
                children: [
                  // ✅ زر سلة المحذوفات - محمي
                  _buildHeaderIcon(
                    Icons.delete_outline,
                    // استخدم guardAction لحماية الزائر
                        () => guardAction(() {
                      if (property.isFavorite) {
                        controller.toggleFavorite(property);
                      }
                    }),
                    color: property.isFavorite ? Colors.red : Colors.grey,
                  ),
                  const SizedBox(width: 10),

                  // ✅ زر القلب - محمي
                  _buildHeaderIcon(
                    property.isFavorite ? Icons.favorite : Icons.favorite_border,
                    // استخدم guardAction لحماية الزائر
                        () => guardAction(() => controller.toggleFavorite(property)),
                    color: property.isFavorite ? Colors.red : Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ويدجيت مساعد لبناء الأزرار الدائرية
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