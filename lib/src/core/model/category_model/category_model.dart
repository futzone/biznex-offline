class Category {
  String name;
  String id;
  String? parentId;
  Map<dynamic, dynamic>? printerParams;
  List<Category>? subcategories;

  Category({required this.name, this.id = '', this.parentId, this.subcategories, this.printerParams});

  factory Category.fromJson(json) {
    return Category(name: json['name'], parentId: json['parentId'], id: json['id'] ?? '', printerParams: json['printerParams'] ?? {});
  }

  Map<String, dynamic> toJson() => {"name": name, "id": id, "parentId": parentId, "printerParams": printerParams};
}
