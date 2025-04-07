import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/model/employee_models/employee_model.dart';
import 'package:biznex/src/core/model/other_models/customer_model.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';

class Order {
  static const String completed = "completed";
  static const String cancelled = "cancelled";
  static const String opened = "opened";
  String id;
  String createdDate;
  String updatedDate;
  Customer? customer;
  Employee employee;
  String? status;
  double? realPrice;
  double price;
  Place place;
  List<OrderItem> products;

  Order({
    required this.place,
    this.id = '',
    this.createdDate = '',
    this.updatedDate = '',
    this.customer,
    required this.employee,
    this.status = 'opened',
    this.realPrice,
    required this.price,
    required this.products,
  });

  factory Order.fromJson(json) {
    return Order(
      id: json['id'] ?? '',
      createdDate: json['createdDate'] ?? '',
      updatedDate: json['updatedDate'] ?? '',
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      employee: Employee.fromJson(json['employee']),
      status: json['status'],
      realPrice: json['realPrice'] != null ? (json['realPrice'] as num).toDouble() : null,
      price: (json['price'] as num).toDouble(),
      products: (json['products'] as List<dynamic>).map((item) => OrderItem.fromJson(item)).toList(),
      place: Place.fromJson(json['place']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place':place.toJson(),
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
