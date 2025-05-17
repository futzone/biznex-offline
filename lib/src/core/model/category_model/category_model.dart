class Category {
  String name;
  String id;
  String? parentId;
  Map<dynamic, dynamic>? printerParams;
  List<Category>? subcategories;
  String? icon;

  Category({required this.name, this.id = '', this.parentId, this.subcategories, this.printerParams, this.icon});

  factory Category.fromJson(json) {
    return Category(
      name: json['name'],
      parentId: json['parentId'],
      id: json['id'] ?? '',
      printerParams: json['printerParams'] ?? {},
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "parentId": parentId,
        "printerParams": printerParams,
        "icon": icon,
      };


}
