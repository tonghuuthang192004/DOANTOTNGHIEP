class CategoryModel {
  final int id;
  final String ten;
  final String hinhAnh;

  CategoryModel({
    required this.id,
    required this.ten,
    required this.hinhAnh,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      ten: json['ten'],
      hinhAnh: json['hinh_anh'],
    );
  }
}
