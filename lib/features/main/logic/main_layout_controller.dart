import 'package:get/get.dart';
import '../../home/ui/screens/add_property_screen.dart';
import '../../notifications/ui/screen/notifications_screen.dart';

class MainLayoutController extends GetxController {
  // ✅ متغير تفاعلي للتبويب الحالي (0: الرئيسية)
  var currentIndex = 0.obs;

  // دالة تغيير التبويب
  void changeTab(int index) {
    currentIndex.value = index;
  }

  // دالة العودة للهوم
  void backToHome() {
    currentIndex.value = 0;
  }

  // الانتقال للشاشات الفرعية
  void navigateToNotifications() => Get.to(() => const NotificationsScreen());
  void navigateToAddProperty() => Get.to(() => const AddPropertyScreen());
}