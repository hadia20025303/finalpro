import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitlednew2/core/theme/app_colors.dart';
import 'package:untitlednew2/core/utils/app_validator.dart';
import 'package:untitlednew2/core/widgets/custom_button.dart';
import 'package:untitlednew2/core/widgets/custom_text_field.dart';
import 'package:untitlednew2/features/auth/ui/screens/forgot_password_screen.dart';
import 'package:untitlednew2/features/onboarding/ui/screens/onboarding_screen.dart';

import '../../../../core/theme/ app_text_styles.dart';
import '../../data/user_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ✅ استدعاء مخزن البيانات
  final UserRepository _userRepo = UserRepository();

  bool _isEditable = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // ✅ تعريف المتحكمات بدون قيم افتراضية هنا
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    // ✅ تحميل البيانات من المخزن عند فتح الصفحة
    _nameController = TextEditingController(text: _userRepo.name);
    _emailController = TextEditingController(text: _userRepo.email);
    _phoneController = TextEditingController(text: _userRepo.phone);
    _imageFile = _userRepo.imageFile;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showSnackBar("حدث خطأ أثناء اختيار الصورة");
    }
  }

  void _handleSave() {
    String? nameErr = AppValidator.validateName(_nameController.text);
    String? emailErr = AppValidator.validateEmail(_emailController.text);
    String? phoneErr = AppValidator.validatePhone(_phoneController.text);

    if (nameErr != null || emailErr != null || phoneErr != null) {
      _showSnackBar(nameErr ?? emailErr ?? phoneErr!);
      return;
    }

    // ✅ حفظ البيانات الجديدة في المخزن لكي لا تضيع
    _userRepo.updateUserData(
      newName: _nameController.text,
      newEmail: _emailController.text,
      newPhone: _phoneController.text,
      newImage: _imageFile,
    );

    setState(() => _isEditable = false);
    _showSnackBar("تم حفظ التعديلات بنجاح", isSuccess: true);
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.right),
        backgroundColor: isSuccess ? Colors.green : Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/aqar.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      _buildProfileAvatar(),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 40),
                          Text(
                            'الملف الشخصي',
                            style: AppTextStyles.font24Bold.copyWith(
                              fontSize: 30,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isEditable ? Icons.check_circle : Icons.edit,
                              color: AppColors.accent,
                            ),
                            onPressed: () {
                              if (_isEditable) {
                                _handleSave(); // حفظ عند الضغط على علامة الصح
                              } else {
                                setState(() => _isEditable = true);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      AbsorbPointer(
                        absorbing: !_isEditable,
                        child: Column(
                          children: [
                            CustomTextField(
                              hintText: 'الاسم الكامل',
                              icon: Icons.person_outline,
                              controller: _nameController,
                              enabled: _isEditable,
                            ),
                            CustomTextField(
                              hintText: 'البريد الإلكتروني',
                              icon: Icons.email_outlined,
                              controller: _emailController,
                              enabled: _isEditable,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            CustomTextField(
                              hintText: 'رقم الهاتف',
                              icon: Icons.phone_android,
                              controller: _phoneController,
                              enabled: _isEditable,
                              keyboardType: TextInputType.phone,
                            ),
                          ],
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen(),
                            ),
                          ),
                          child: const Text(
                            'تغيير كلمة المرور؟',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      if (_isEditable)
                        CustomButton(
                          text: 'حفظ التغييرات',
                          onPressed: _handleSave,
                        ),

                      const SizedBox(height: 15),
                      CustomButton(
                        text: 'تسجيل الخروج',
                        backgroundColor: AppColors.primary.withOpacity(0.7),
                        onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnboardingScreen(),
                          ),
                          (route) => false,
                        ),
                      ),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: AppColors.background, width: 5),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFFFD1E8),
            backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
            child: _imageFile == null
                ? const Icon(Icons.person, size: 80, color: Colors.grey)
                : null,
          ),
        ),
        if (_isEditable)
          Positioned(
            bottom: 5,
            left: 5,
            child: PopupMenuButton<int>(
              offset: const Offset(0, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onSelected: (value) => value == 1
                  ? _pickImage(ImageSource.camera)
                  : _pickImage(ImageSource.gallery),
              child: CircleAvatar(
                backgroundColor: AppColors.accent,
                radius: 18,
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              itemBuilder: (context) => [
                _buildPopupOption(1, Icons.camera_alt_outlined, 'التقاط صورة'),
                _buildPopupOption(2, Icons.photo_library_outlined, 'من المعرض'),
              ],
            ),
          ),
      ],
    );
  }

  PopupMenuItem<int> _buildPopupOption(int value, IconData icon, String text) {
    return PopupMenuItem(
      value: value,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 22),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.darkNavy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
