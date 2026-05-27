import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/property_model.dart';
import '../data/models/property_repository.dart';

class PropertyDetailsController extends GetxController {
  final PropertyRepository _repo = PropertyRepository();

  // ✅ دالة التبديل للمفضلة (نفس منطقك الأصلي مع GetX)
  void toggleFavorite(PropertyModel property) {
    _repo.toggleFavorite(property.id);

    // تحديث الواجهة يدوياً لضمان استجابة Obx
    update();

    bool isFav = property.isFavorite;
    Get.snackbar(
      "تنبيه",
      isFav ? "تمت الإضافة للمفضلة ❤️" : "تمت الإزالة من المفضلة",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isFav ? Colors.green : Colors.redAccent,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.all(15),
    );
  }

  void goBack() {
    Get.back();
  }
}