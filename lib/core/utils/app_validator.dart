class AppValidator {
  // 1. التحقق من الاسم
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'يرجى إدخال الاسم الكامل';
    if (value.trim().length < 3) return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    return null;
  }

  // 2. التحقق الصارم من البريد الإلكتروني (يسمح بـ .com فقط)
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }

    // أولاً: التحقق من الصيغة العامة (وجود @ ونقطة)
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    );

    if (!emailRegExp.hasMatch(value)) {
      return 'صيغة البريد الإلكتروني غير صحيحة';
    }

    // ✅ ثانياً: الشرط الصارم - القبول فقط وحصراً إذا كان ينتهي بـ .com
    // استخدمنا toLowerCase لضمان التحقق حتى لو كتب المستخدم .COM بأحرف كبيرة
    if (!value.toLowerCase().endsWith('.com')) {
      return 'يجب أن ينتهي البريد الإلكتروني بـ .com حصراً';
    }

    return null;
  }

  // 3. التحقق من رقم الهاتف
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'يرجى إدخال رقم الهاتف';
    if (value.trim().length < 10) return 'رقم الهاتف يجب أن يكون 10 أرقام';
    return null;
  }

  // 4. التحقق من كلمة السر
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'يرجى إدخال كلمة السر';
    if (value.length < 8) return 'يجب أن تكون كلمة السر 8 أحرف على الأقل';
    return null;
  }

  // 5. التأكد من تطابق كلمتي السر
  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty)
      return 'يرجى تأكيد كلمة السر';
    if (password != confirmPassword) return 'كلمتا السر غير متطابقتين';
    return null;
  }

  // 6. التحقق من السجل التجاري للوكلاء
  static String? validateCommercialId(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'يرجى إدخال رقم السجل التجاري';
    return null;
  }
}
