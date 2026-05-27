// lib/features/home/logic/home_controller.dart
// ✅ toggleFavorite تستخدم guardAction بدل dialog مكرر

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/guest_guard.dart';           // ✅
import '../data/models/property_repository.dart';

class HomeController extends GetxController {
  final PropertyRepository _repo = PropertyRepository();
  final ScrollController scrollController = ScrollController();

  var showBackToTopButton = false.obs;
  var displayProperties = <dynamic>[].obs;

  void initData(String? selectedArea) {
    if (displayProperties.isEmpty) {
      if (selectedArea != null) {
        displayProperties.assignAll(
          _repo.allProperties.where((p) => p.area.contains(selectedArea)).toList(),
        );
      } else {
        displayProperties.assignAll(_repo.allProperties);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.offset > 300) {
        if (!showBackToTopButton.value) showBackToTopButton.value = true;
      } else {
        if (showBackToTopButton.value) showBackToTopButton.value = false;
      }
    });
  }

  // ✅ guardAction تتكفل بكل شيء: إذا زائر → Dialog، إذا مسجّل → ينفّذ
  void toggleFavorite(String id) {
    guardAction(() {
      _repo.toggleFavorite(id);
      displayProperties.refresh();

      final isFav = _repo.allProperties.firstWhere((p) => p.id == id).isFavorite;
      Get.snackbar(
        "تنبيه",
        isFav ? "تمت الإضافة إلى المفضلة ❤️" : "تمت الإزالة من المفضلة",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isFav ? Colors.green : Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
        margin: const EdgeInsets.all(15),
      );
    });
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
