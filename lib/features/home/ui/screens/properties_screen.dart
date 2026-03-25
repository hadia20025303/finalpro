import 'package:flutter/material.dart';
import 'package:untitlednew2/core/theme/app_colors.dart';

import '../../../../core/theme/ app_text_styles.dart';
import '../../data/models/property_model.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  // ✅ إضافة الـ id لكل عنصر لحل المشكلة
  final List<PropertyModel> properties = [
    PropertyModel(
      id: "1", // تم إضافة المعرف هنا
      title: "فيلا المزة في دمشق",
      area: "دمشق - المزة",
      size: "300 م²",
      price: "900,000,000 ل.س",
      imageUrl: "images/aqar.jpeg",
    ),
    PropertyModel(
      id: "2", // تم إضافة المعرف هنا
      title: "شقة مشروع دمر",
      area: "دمشق - مشروع دمر",
      size: "150 م²",
      price: "450,000,000 ل.س",
      imageUrl: "images/aqar.jpeg",
    ),
    PropertyModel(
      id: "3", // تم إضافة المعرف هنا
      title: "مكتب تجاري حلب",
      area: "حلب - الشهباء",
      size: "100 م²",
      price: "300,000,000 ل.س",
      imageUrl: "images/aqar.jpeg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            // 1. الخلفية
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/aqar.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 2. زر الرجوع الدائري
            Positioned(
              top: 50,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
            ),

            // 3. الكرت الأبيض المنحني والمحتوى
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      'قائمة العقارات',
                      style: AppTextStyles.font24Bold.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'تصفح أفضل العروض العقارية المتاحة',
                      style: AppTextStyles.font14GreyRegular,
                    ),
                    const SizedBox(height: 25),

                    // قائمة العقارات
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: properties.length,
                        itemBuilder: (context, index) =>
                            _buildPropertyItem(index),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ ويدجيت الكرت بتعديل الاتجاه الجديد (يمين: صورة واسم | يسار: بيانات)
  Widget _buildPropertyItem(int index) {
    final property = properties[index];
    return Container(
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
          // القسم الأيسر: البيانات
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      property.isFavorite = !property.isFavorite;
                    });
                  },
                  child: Icon(
                    property.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: property.isFavorite ? Colors.red : AppColors.accent,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  property.price,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "المساحة: ${property.size}",
                  style: const TextStyle(color: AppColors.grey, fontSize: 12),
                ),
                Text(
                  "الموقع: ${property.area}",
                  style: const TextStyle(color: AppColors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(width: 15),

          // القسم الأيمن: الصورة والاسم
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
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
