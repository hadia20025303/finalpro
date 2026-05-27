import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/data/models/property_repository.dart';

class FavoritesController extends GetxController {
  final PropertyRepository _repo = PropertyRepository();
  final ScrollController scrollController = ScrollController();
  var showBackToTopButton = false.obs;
  var favList = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();

    // ✅ مراقبة "البنك المركزي" (allProperties)
    // أي تغيير يحدث في القلب الأحمر في أي مكان، سيتم تحديث favList تلقائياً
    ever(_repo.allProperties, (_) => loadFavorites());

    loadFavorites();

    scrollController.addListener(() {
      if (scrollController.offset > 200) {
        if (!showBackToTopButton.value) showBackToTopButton.value = true;
      } else {
        if (showBackToTopButton.value) showBackToTopButton.value = false;
      }
    });
  }

  void loadFavorites() {
    favList.assignAll(_repo.getFavoriteProperties());
  }

  void scrollToTop() {
    scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
  }

  void removeFromFavorites(String id) {
    _repo.toggleFavorite(id); // سيقوم المخزن بعمل refresh وتحديث favList تلقائياً بسبب ever

    Get.snackbar("تنبيه", "تمت إزالة العقار من المفضلة",
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
  }
}