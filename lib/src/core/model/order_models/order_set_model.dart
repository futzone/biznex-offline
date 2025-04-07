import 'package:biznex/src/core/model/product_models/product_model.dart';

class OrderItem {
  Product product;
  double amount;
  double? customPrice;
  String placeId;

  OrderItem({
    required this.product,
    this.customPrice,
    required this.amount,
    required this.placeId,
  });

  OrderItem copyWith({
    Product? product,
    double? amount,
    double? customPrice,
    String? placeId,
  }) {
    return OrderItem(
      product: product ?? this.product,
      amount: amount ?? this.amount,
      customPrice: customPrice ?? this.customPrice,
      placeId: placeId ?? this.placeId,
    );
  }

  factory OrderItem.fromJson(json) {
    return OrderItem(
      product: Product.fromJson(json['product']),
      amount: (json['amount'] as num).toDouble(),
      placeId: (json['placeId']),
      customPrice: json['customPrice'] != null ? (json['customPrice'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId,
      'product': product.toJson(),
      'amount': amount,
      'customPrice': customPrice,
    };
  }
}
