class PropertyModel {
  final String id;
  final String title;
  final String area;
  final String size;
  final String price;
  final String imageUrl;
  bool isFavorite; // ✅ مضاف للتحكم في حالة القلب

  PropertyModel({
    required this.id,
    required this.title,
    required this.area,
    required this.size,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false, // القيمة الافتراضية غير مفضل
  });
}