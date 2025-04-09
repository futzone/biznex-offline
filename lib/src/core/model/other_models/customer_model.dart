class Customer {
  String name;
  String phone;
  String id;

  Customer({this.id = '', required this.name, required this.phone});

  factory Customer.fromJson(json) {
    return Customer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }
}
