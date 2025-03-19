class Role {
  String id;
  String name;

  Role({this.id = '', required this.name});

  factory Role.fromJson(json) {
    return Role(name: json['name'], id: json['id']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
