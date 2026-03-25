class ApiKeys {
  // -------------------------------------------------------------------------
  // القسم 1: الحساب والبروفايل (تم إنجاز واجهاتها)
  // -------------------------------------------------------------------------

  /// البريد الإلكتروني للمستخدم
  static const String email = 'email';

  /// كلمة المرور
  static const String password = 'password';

  /// تأكيد كلمة المرور
  static const String passwordConfirm = 'password_confirmation';

  /// الاسم الكامل للمستخدم
  static const String fullName = 'name';

  /// رقم الهاتف
  static const String phoneNumber = 'phone';

  /// ملف الصورة الشخصية (الذي نلتقطه بالكاميرا أو المعرض)
  static const String avatar = 'avatar';

  /// رقم السجل التجاري (خاص بالوكيل العقاري)
  static const String commercialId = 'commercial_registration_id';

  // -------------------------------------------------------------------------
  // القسم 2: التحقق واستعادة الحساب (تم إنجاز واجهاتها)
  // -------------------------------------------------------------------------

  /// رمز التحقق OTP (المكون من 4 مربعات التي صممناها)
  static const String otpCode = 'otp_code';

  // -------------------------------------------------------------------------
  // القسم 3: الفلترة والموقع (تم إنجاز واجهاتها)
  // -------------------------------------------------------------------------

  /// معرف الدولة (سوريا)
  static const String country = 'country_id';

  /// معرف المحافظة (دمشق، حلب، إلخ)
  static const String governorate = 'governorate_id';

  /// معرف المنطقة أو الحي (المزة، الجميلية، إلخ)
  static const String area = 'area_id';

  // -------------------------------------------------------------------------
  // القسم 4: بيانات العقار (يستخدم في الهوم والمفضلة والتفاصيل حالياً)
  // -------------------------------------------------------------------------

  /// المعرف الفريد لكل منشور عقاري (الـ ID لفتح التفاصيل)
  static const String propertyId = 'id';

  /// عنوان العقار
  static const String propertyTitle = 'title';

  /// مساحة العقار
  static const String propertySize = 'size';

  /// سعر العقار
  static const String propertyPrice = 'price';

  /// رابط الصورة التي تظهر في الكرت
  static const String propertyImage = 'image_url';

  /// حالة القلب (مفضل أو لا) لربطها بقاعدة البيانات
  static const String isFavorite = 'is_favorite';
}