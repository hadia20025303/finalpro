import 'dart:io';
import 'package:get/get.dart';

class UserRepository extends GetxService {
  // ✅ جعل المتغيرات تفاعلية (.obs) لكي تشعر بها الواجهات فوراً
  var name = "هادية عبد".obs;
  var email = "hadiaabd47@gmail.com".obs;
  var phone = "0983391340".obs;
  var imageFile = Rxn<File>(); // متغير يقبل File أو null بشكل تفاعلي

  // ✅ دالة تحديث البيانات (ستستخدم عند الحفظ)
  void updateUserData({
    required String newName,
    required String newEmail,
    required String newPhone,
    File? newImage,
  }) {
    name.value = newName;
    email.value = newEmail;
    phone.value = newPhone;
    if (newImage != null) {
      imageFile.value = newImage;
    }

    // ملاحظة للباك إيند مستقبلاً:
    // هنا سنضيف كود إرسال البيانات للسيرفر عبر API
  }

  // دالة لتصفير البيانات عند تسجيل الخروج
  void clearUserData() {
    name.value = "";
    email.value = "";
    phone.value = "";
    imageFile.value = null;
  }
}