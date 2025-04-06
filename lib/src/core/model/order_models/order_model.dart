import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/model/employee_models/employee_model.dart';
import 'package:biznex/src/core/model/other_models/customer_model.dart';

class Order {
  String id;
  String createdDate;
  String updatedDate;
  Customer? customer;
  Employee employee;
  String? status;
  double? realPrice;
  double price;
  List<OrderItem> products;

  Order({
    this.id = '',
    this.createdDate = '',
    this.updatedDate = '',
    this.customer,
    required this.employee,
    this.status = 'completed',
    this.realPrice,
    required this.price,
    required this.products,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      createdDate: json['createdDate'] ?? '',
      updatedDate: json['updatedDate'] ?? '',
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,
      employee: Employee.fromJson(json['employee']),
      status: json['status'],
      realPrice: json['realPrice'] != null
          ? (json['realPrice'] as num).toDouble()
          : null,
      price: (json['price'] as num).toDouble(),
      products: (json['products'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'customer': customer?.toJson(),
      'employee': employee.toJson(),
      'status': status,
      'realPrice': realPrice,
      'price': price,
      'products': products.map((e) => e.toJson()).toList(),
    };
  }
}
