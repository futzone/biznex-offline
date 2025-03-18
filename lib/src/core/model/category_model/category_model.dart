class Category {
  String name;
  String id;
  String? parentId;
  List<Category>? subcategories;

  Category({required this.name, this.id = '', this.parentId, this.subcategories});

  factory Category.fromJson(json) {
    return Category(name: json['name'], parentId: json['parentId'], id: json['id'] ?? '');
  }

  Map<String, dynamic> toJson() => {"name": name, "id": id, "parentId": parentId};
}
