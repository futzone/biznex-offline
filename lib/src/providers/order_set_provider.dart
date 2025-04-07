import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/order_controller.dart';
import 'package:biznex/src/core/database/order_database/order_database.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:biznex/src/providers/orders_provider.dart';

final orderSetProvider = StateNotifierProvider<OrderSetNotifier, List<OrderItem>>((ref) {
  return OrderSetNotifier(ref);
});

class OrderSetNotifier extends StateNotifier<List<OrderItem>> {
  final Ref ref;

  OrderSetNotifier(this.ref) : super([]);

  void addItem(OrderItem item) {
    final index = state.indexWhere((e) => e.product.id == item.product.id && e.placeId == item.placeId);
    if (index != -1) {
      final updatedItem = state[index].copyWith(amount: state[index].amount + 1);
      state = [...state]..[index] = updatedItem;
    } else {
      state = [...state, item];
    }
  }

  void removeItem(OrderItem item) {
    final index = state.indexWhere((e) => e.product.id == item.product.id && e.placeId == item.placeId);
    if (index != -1) {
      final current = state[index];
      if (current.amount > 1) {
        final updatedItem = current.copyWith(amount: current.amount - 1);
        state = [...state]..[index] = updatedItem;
      } else {
        deleteItem(item);
      }
    }
  }

  void deleteItem(OrderItem item) async {
    OrderDatabase database = OrderDatabase();

    final order = ref.watch(ordersProvider(item.placeId)).value;
    if (order == null || order.products.isEmpty) {
      state = state.where((e) => !(e.product.id == item.product.id && e.placeId == item.placeId)).toList();
      return;
    }

    Order kOrder = order;
    kOrder.products = [...order.products.where((el) => el.product.id != item.product.id)];

    await database.updatePlaceOrder(data: kOrder, placeId: item.placeId);

    ref.invalidate(ordersProvider(item.placeId));

    state = state.where((e) => !(e.product.id == item.product.id && e.placeId == item.placeId)).toList();
  }

  void updateItem(OrderItem item) {
    final index = state.indexWhere((e) => e.product.id == item.product.id && e.placeId == item.placeId);
    if (index != -1) {
      state = [...state]..[index] = item;
    } else {
      state = [...state, item];
    }
  }

  List<OrderItem> getItemsByPlace(String placeId) {
    return state.where((e) => e.placeId == placeId).toList();
  }

  void clearPlaceItems(String placeId) {
    state = state.where((e) => e.placeId != placeId).toList();
  }

  void addMultiple(List<OrderItem> items) {
    final current = state;
    final currentIds = current.map((e) => e.product.id).toSet();
    final unique = items.where((e) => !currentIds.contains(e.product.id)).toList();
    state = [...current, ...unique];
  }

  void clear() => state = [];
}
