import 'dart:io';

class UserRepository {
  // ✅ جعل الكلاس Singleton لضمان وجود نسخة واحدة فقط في الذاكرة
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;
  UserRepository._internal();

  // المتغيرات التي سيتم حفظها
  String name = "هادية عبد";
  String email = "hadiaabd47@gmail.com";
  String phone = "0983391340";
  File? imageFile;

  // دالة لتحديث البيانات
  void updateUserData({required String newName, required String newEmail, required String newPhone, File? newImage}) {
    name = newName;
    email = newEmail;
    phone = newPhone;
    if (newImage != null) imageFile = newImage;
  }
}