import 'dart:developer';

import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/order_controller.dart';
import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/core/database/order_database/order_database.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:biznex/src/providers/orders_provider.dart';
import 'package:biznex/src/providers/products_provider.dart';
import 'package:biznex/src/ui/pages/login_pages/login_page.dart';

final orderSetProvider = StateNotifierProvider<OrderSetNotifier, List<OrderItem>>((ref) {
  return OrderSetNotifier(ref);
});

class OrderSetNotifier extends StateNotifier<List<OrderItem>> {
  final Ref ref;

  OrderSetNotifier(this.ref) : super([]);

  void addItem(OrderItem item) {
    final index = state.indexWhere((e) => e.product.id == item.product.id && e.placeId == item.placeId);
    if (index != -1) {
      final updatedItemObject = state[index];
      if (updatedItemObject.product.amount >= updatedItemObject.amount + 1) {
        final updatedItem = state[index].copyWith(amount: state[index].amount + 1);
        state = [...state]..[index] = updatedItem;
      }
    } else {
      if (item.product.amount >= 1) state = [...state, item];
    }

    ref.invalidate(productsProvider);
  }

  void removeItem(OrderItem item, AppModel model, context) {
    final index = state.indexWhere((e) => e.product.id == item.product.id && e.placeId == item.placeId);
    if (index != -1) {
      final current = state[index];
      if (current.amount > 1) {
        final updatedItem = current.copyWith(amount: current.amount - 1);
        state = [...state]..[index] = updatedItem;
      } else {
        deleteItem(item, model, context);
      }
    }
  }

  void deleteItem(OrderItem item, AppModel model, context) {
    final order = ref.watch(ordersProvider(item.placeId)).value;

    if (order != null && order.products.isNotEmpty && order.products.any((element) => element.product.id == item.product.id)) {
      AppRouter.go(
        context,
        LoginPageHarom(
          model: model,
          theme: AppColors(isDark: model.isDark),
          onSuccessEnter: () {
            final index = state.indexWhere((e) => e.product.id == item.product.id && e.placeId == item.placeId);
            if (index != -1) {
              state = [...state.where((e) => !(e.product.id == item.product.id && e.placeId == item.placeId))];
            }
          },
        ),
      );

      return;
    }

    final index = state.indexWhere((e) => e.product.id == item.product.id && e.placeId == item.placeId);
    if (index != -1) {
      state = [...state.where((e) => !(e.product.id == item.product.id && e.placeId == item.placeId))];
    }
    return;
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
    final currentKeys = current.map((e) => '${e.product.id}-${e.placeId}').toSet();
    final unique = items.where((e) => !currentKeys.contains('${e.product.id}-${e.placeId}')).toList();
    state = [...current, ...unique];
  }

  void clear() => state = [];
}
