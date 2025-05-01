class Employee {
  String id;
  String fullname;
  String createdDate;
  String? phone;
  String? description;
  String roleId;
  String roleName;
  String pincode;

  Employee({
    this.pincode = '',
    this.id = '',
    this.phone,
    this.description,
    this.createdDate = '',
    required this.fullname,
    required this.roleId,
    required this.roleName,
  });

  factory Employee.fromJson(json) {
    return Employee(
      fullname: json['fullname'],
      createdDate: json['createdDate'],
      description: json['description'],
      phone: json['phone'],
      id: json['id'],
      roleId: json['roleId'],
      roleName: json['roleName'],
      pincode: json['pincode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "createdDate": createdDate,
        "description": description,
        "phone": phone,
        "id": id,
        "roleName": roleName,
        "roleId": roleId,
        "pincode": pincode,
      };
}
