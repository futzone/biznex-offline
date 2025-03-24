import 'dart:core';
import 'package:biznex/src/core/extensions/for_dynamic.dart';
import 'package:biznex/src/core/model/product_params_models/product_info.dart';
import 'package:biznex/src/core/utils/product_utils.dart';

class Product {
  String name;
  String? barcode;
  String? tagnumber;
  String? cratedDate;
  String? updatedDate;
  List<ProductInfo>? informations;
  String? description;
  String? imagePath;
  String? measure;
  String? color;
  String? colorCode;
  String? size;
  double price;
  double amount;
  double percent;
  String id;
  String? productId;
  List<Product>? variants;

  Product({
    required this.name,
    required this.price,
    this.barcode,
    this.tagnumber,
    this.cratedDate,
    this.updatedDate,
    this.informations,
    this.description,
    this.imagePath,
    this.measure,
    this.size,
    this.id = '',
    this.percent = 0,
    this.color,
    this.productId,
    this.amount = 1,
    this.colorCode,
    this.variants,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'barcode': barcode ?? ProductUtils.newBarcode,
      'tagnumber': tagnumber ?? ProductUtils.newTagnumber,
      'cratedDate': cratedDate ?? DateTime.now().toIso8601String(),
      'updatedDate': updatedDate ?? DateTime.now().toIso8601String(),
      'informations': informations?.map((e) => e.toJson()).toList(),
      'description': description,
      'imagePath': imagePath,
      'measure': measure,
      'color': color,
      'colorCode': colorCode,
      'size': size,
      'price': price,
      'amount': amount,
      'percent': percent,
      'id': id.notNullOrEmpty(ProductUtils.generateID),
      'productId': productId,
      'variants': variants?.map((e) => e.toJson()).toList(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      barcode: json['barcode'] ?? '',
      tagnumber: json['tagnumber'] ?? '',
      cratedDate: json['cratedDate'] ?? '',
      updatedDate: json['updatedDate'] ?? '',
      informations: (json['informations'] as List<dynamic>?)?.map((e) => ProductInfo.fromJson(e)).toList(),
      description: json['description'],
      imagePath: json['imagePath'],
      measure: json['measure'],
      color: json['color'],
      colorCode: json['colorCode'],
      size: json['size'],
      price: (json['price'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      percent: (json['percent'] as num).toDouble(),
      id: json['id'] ?? '',
      productId: json['productId'],
      variants: (json['variants'] as List<dynamic>?)?.map((e) => Product.fromJson(e)).toList(),
    );
  }
}
