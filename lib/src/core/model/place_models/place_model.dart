class Place {
  String name;
  String id;
  String? image;
  List<Place>? children;
  Place? father;

  Place({
    this.father,
    required this.name,
    this.image,
    this.children,
    this.id = '',
  });

  factory Place.fromJson(json, {dynamic fatherId}) {
    return Place(
      father: json['father'] == null ? Place(name: '', id: fatherId ?? '') : Place.fromJson(json['father']),
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      image: json['image'],
      children: (json['children'] as List?)?.map((mp) => Place.fromJson(mp, fatherId: json['id'] ?? '')).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'image': image,
      'children': children != null ? children!.map((mp) => mp.toJsonWithoutChildren()).toList() : [],
      'father': father?.toJsonWithoutChildren(),
    };
  }

  Map<String, dynamic> toJsonWithoutChildren() {
    return {
      'name': name,
      'id': id,
      'image': image,
      'father': father?.toJsonWithoutChildren(),
    };
  }
}
