import '../models/property_model.dart';

class PropertyRepository {
  // ✅ جعل المخزن "Single Instance" لكي لا تتغير البيانات عند التنقل
  static final PropertyRepository _instance = PropertyRepository._internal();
  factory PropertyRepository() => _instance;
  PropertyRepository._internal();

  // القائمة الرئيسية للعقارات
  final List<PropertyModel> allProperties = [
    PropertyModel(
      id: "1",
      title: "فيلا المزة",
      area: "دمشق - المزة",
      size: "300 م²",
      price: "900M",
      imageUrl: "images/aqar.jpeg",
    ),
    PropertyModel(
      id: "2",
      title: "شقة الشهباء",
      area: "حلب - الشهباء",
      size: "150 م²",
      price: "450M",
      imageUrl: "images/aqar.jpeg",
    ),
    PropertyModel(
      id: "3",
      title: "مكتب بانياس",
      area: "طرطوس - بانياس",
      size: "100 م²",
      price: "300M",
      imageUrl: "images/aqar.jpeg",
    ),
  ];

  // دالة لجلب المفضلات فقط
  List<PropertyModel> getFavoriteProperties() {
    return allProperties.where((p) => p.isFavorite).toList();
  }

  // دالة لتبديل حالة المفضلة
  void toggleFavorite(String id) {
    final index = allProperties.indexWhere((p) => p.id == id);
    if (index != -1) {
      allProperties[index].isFavorite = !allProperties[index].isFavorite;
    }
  }
}
