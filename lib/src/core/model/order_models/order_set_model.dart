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
}
