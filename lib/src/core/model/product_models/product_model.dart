import 'dart:core';
import 'dart:developer';
import 'package:biznex/src/core/extensions/for_dynamic.dart';
import 'package:biznex/src/core/model/category_model/category_model.dart';
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
  List<String>? images;
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
  Category? category;

  Product({
    required this.name,
    required this.price,
    this.barcode,
    this.tagnumber,
    this.cratedDate,
    this.updatedDate,
    this.informations,
    this.description,
    this.images,
    this.measure,
    this.size,
    this.id = '',
    this.percent = 0,
    this.color,
    this.productId,
    this.amount = 1,
    this.colorCode,
    this.variants,
    this.category,
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
      'images': images,
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
      'category': category?.toJson(),
    };
  }

  factory Product.fromJson(json) {
    if (json['name'].toString().contains("Kos")) log(json.toString());
    return Product(
      name: json['name'],
      barcode: json['barcode'] ?? '',
      tagnumber: json['tagnumber'] ?? '',
      cratedDate: json['cratedDate'] ?? '',
      updatedDate: json['updatedDate'] ?? '',
      informations: (json['informations'] as List<dynamic>?)?.map((e) => ProductInfo.fromJson(e)).toList(),
      description: json['description'],
      images: json['images'],
      measure: json['measure'],
      color: json['color'],
      colorCode: json['colorCode'],
      size: json['size'],
      price: (json['price'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      percent: (json['percent'] as num).toDouble(),
      id: json['id'] ?? '',
      productId: json['productId'],
      category: json['category'] == null ? null : Category.fromJson(json['category']),
      variants: (json['variants'] as List<dynamic>?)?.map((e) => Product.fromJson(e)).toList(),
    );
  }
}
