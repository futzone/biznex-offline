class Place {
  String name;
  String id;
  String? image;
  List<Place>? children;

  Place({
    required this.name,
    this.image,
    this.children,
    this.id = '',
  });

  factory Place.fromJson(json) {
    return Place(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      image: json['image'],
      children: (json['children'] as List?)?.map((mp) => Place.fromJson(mp)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'image': image,
      'children': children?.map((mp) => mp.toJson()).toList(),
    };
  }
}
