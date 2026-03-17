class ProductModel {
  final String id;
  final String name;
  final Map<String, dynamic>? data;

  ProductModel({required this.id, required this.name, this.data});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      name: json['name'] ?? 'No Name',
      data: json['data'],
    );
  }
}
