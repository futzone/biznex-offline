import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/model/order_models/order_set_model.dart';

final StateProvider<List<OrderItem>> orderSetProvider = StateProvider((ref) => []);

void updateOrderItem(WidgetRef ref, OrderItem updatedItem) {
  ref.read(orderSetProvider.notifier).state = ref
      .read(orderSetProvider)
      .where((item) => item.product.id != updatedItem.product.id || updatedItem.amount > 0)
      .map((item) => item.product.id == updatedItem.product.id ? updatedItem : item)
      .toList();
}

void addOrUpdateOrderItem(WidgetRef ref, OrderItem newItem) {
  ref.read(orderSetProvider.notifier).state = ref.read(orderSetProvider).map((item) {
    if (item.product.id == newItem.product.id) {
      return item.copyWith(amount: item.amount + 1);
    }
    return item;
  }).toList();

  if (!ref.read(orderSetProvider).any((item) => item.product.id == newItem.product.id)) {
    ref.read(orderSetProvider.notifier).state = [
      ...ref.read(orderSetProvider),
      newItem.copyWith(amount: 1),
    ];
  }
}
