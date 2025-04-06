import 'package:biznex/src/core/model/product_models/product_model.dart';

class OrderItem {
  Product product;
  double amount;
  double? customPrice;

  OrderItem({
    required this.product,
    this.customPrice,
    required this.amount,
  });

  OrderItem copyWith({
    Product? product,
    double? amount,
    double? customPrice,
  }) {
    return OrderItem(
      product: product ?? this.product,
      amount: amount ?? this.amount,
      customPrice: customPrice ?? this.customPrice,
    );
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      product: Product.fromJson(json['product']),
      amount: (json['amount'] as num).toDouble(),
      customPrice: json['customPrice'] != null ? (json['customPrice'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'amount': amount,
      'customPrice': customPrice,
    };
  }
}
