class Employee {
  String id;
  String fullname;
  String createdDate;
  String? phone;
  String? description;

  Employee({
    this.id = '',
    this.phone,
    this.description,
    this.createdDate = '',
    required this.fullname,
  });

  factory Employee.fromJson(json) {
    return Employee(
      fullname: json['fullname'],
      createdDate: json['createdDate'],
      description: json['description'],
      phone: json['phone'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "createdDate": createdDate,
        "description": description,
        "phone": phone,
        "id": id,
      };
}
