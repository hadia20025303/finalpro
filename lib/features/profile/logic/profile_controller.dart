import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitlednew2/core/utils/app_validator.dart';
import '../data/user_repository.dart';

class ProfileController extends GetxController {
  // ✅ الوصول لمخزن البيانات المركزي
  final UserRepository _userRepo = Get.find<UserRepository>();

  // ✅ متغيرات الحالة التفاعلية
  var isEditable = false.obs;
  var tempImageFile = Rxn<File>(); // صورة مؤقتة قبل الحفظ
  final ImagePicker _picker = ImagePicker();

  // ✅ المتحكمات النصية
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void onInit() {
    super.onInit();
    // تحميل البيانات من المخزن عند البداية
    nameController = TextEditingController(text: _userRepo.name.value);
    emailController = TextEditingController(text: _userRepo.email.value);
    phoneController = TextEditingController(text: _userRepo.phone.value);
    tempImageFile.value = _userRepo.imageFile.value;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // تبديل وضع التعديل
  void toggleEdit() {
    if (isEditable.value) {
      handleSave();
    } else {
      isEditable.value = true;
    }
  }

  // التقاط صورة
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
      if (pickedFile != null) {
        tempImageFile.value = File(pickedFile.path);
      }
    } catch (e) {
      showError("حدث خطأ أثناء اختيار الصورة");
    }
  }

  // حفظ البيانات
  void handleSave() {
    String? nameErr = AppValidator.validateName(nameController.text);
    String? emailErr = AppValidator.validateEmail(emailController.text);
    String? phoneErr = AppValidator.validatePhone(phoneController.text);

    if (nameErr != null || emailErr != null || phoneErr != null) {
      showError(nameErr ?? emailErr ?? phoneErr!);
      return;
    }

    // تحديث المخزن المركزي (Repository)
    _userRepo.updateUserData(
      newName: nameController.text,
      newEmail: emailController.text,
      newPhone: phoneController.text,
      newImage: tempImageFile.value,
    );

    isEditable.value = false;
    Get.snackbar("نجاح", "تم حفظ التعديلات بنجاح",
        backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
  }

  void showError(String message) {
    Get.snackbar("تنبيه", message, backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
  }
}