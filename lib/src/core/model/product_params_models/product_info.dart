class ProductInfo {
  String name;
  String data;
  String id;

  ProductInfo({required this.id, required this.name, required this.data});

  factory ProductInfo.fromJson(Map<dynamic, dynamic> json) {
    return ProductInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      data: json['data'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'data': data};
  }
}
