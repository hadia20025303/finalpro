// lib/features/main/logic/main_layout_controller.dart
// ✅ يستخدم AuthController بدل UserRepository للتحقق من الزائر

import 'package:get/get.dart';
import '../../../../core/controllers/auth_controller.dart';   // ✅
import '../../../../core/utils/guest_guard.dart';              // ✅
import '../../auth/ui/screens/get_started_screen.dart';
import '../../home/ui/screens/add_property_screen.dart';
import '../../notifications/ui/screen/notifications_screen.dart';

class MainLayoutController extends GetxController {
  var currentIndex = 0.obs;

  // ─────────────────────────────────────────
  // تغيير التبويب
  //   0 = الرئيسية  ← مسموح للجميع
  //   1 = المفضلة   ← محمي
  //   2 = الشات     ← محمي
  //   3 = البروفايل ← محمي
  // ─────────────────────────────────────────
  void changeTab(int index) {
    if (index == 0) {
      // الرئيسية: مسموح دائماً
      currentIndex.value = index;
      return;
    }

    // باقي التبويبات: محمية بـ guardAction
    guardAction(() => currentIndex.value = index);
  }

  // العودة للهوم
  void backToHome() {
    currentIndex.value = 0;
  }

  // ✅ الإشعارات: محمية
  void navigateToNotifications() {
    guardAction(() => Get.to(() => const NotificationsScreen()));
  }

  // ✅ إضافة عقار: محمية
  void navigateToAddProperty() {
    guardAction(() => Get.to(() => const AddPropertyScreen()));
  }
}
