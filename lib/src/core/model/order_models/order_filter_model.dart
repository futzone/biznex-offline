import 'package:biznex/src/core/model/employee_models/employee_model.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
import 'package:biznex/src/core/model/product_models/product_model.dart';

class OrderFilterModel {
  String? employee;
  DateTime? dateTime;
  String? status;
  String? product;
  String? place;

  bool isActive() => employee != null || dateTime != null || status != null || product != null || place != null;

  OrderFilterModel({
    this.place,
    this.product,
    this.dateTime,
    this.employee,
    this.status,
  });
}
