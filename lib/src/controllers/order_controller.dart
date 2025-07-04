import 'dart:developer';
import 'package:biznex/src/controllers/transaction_controller.dart';
import 'package:biznex/src/core/model/transaction_model/transaction_model.dart';
import 'package:biznex/src/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biznex/biznex.dart'; // Assuming AppLocales is here
import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/core/database/order_database/order_database.dart';
import 'package:biznex/src/core/database/order_database/order_percent_database.dart';
import 'package:biznex/src/core/database/product_database/product_database.dart';
import 'package:biznex/src/core/model/employee_models/employee_model.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:biznex/src/core/model/other_models/customer_model.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
import 'package:biznex/src/core/model/product_models/product_model.dart';
import 'package:biznex/src/core/services/printer_multiple_services.dart';
import 'package:biznex/src/core/services/printer_services.dart';
import 'package:biznex/src/providers/employee_orders_provider.dart';
import 'package:biznex/src/providers/orders_provider.dart'; // Assuming orderSetProvider is here or accessible
import 'package:biznex/src/ui/widgets/custom/app_loading.dart';
import 'package:biznex/src/ui/widgets/custom/app_toast.dart';

import '../core/model/app_changes_model.dart';

// Placeholder for AppLocales if it's not in biznex/biznex.dart
// class AppLocales {
//   static String get orderCreatedSuccessfully => 'Order created successfully';
//   static String get orderClosedSuccessfully => 'Order closed successfully';
// }
// extension StringExtension on String {
//   String tr() => this; // Placeholder
// }
// Placeholder for orderSetProvider
// final orderSetProvider = StateNotifierProvider<OrderSetNotifier, List<OrderItem>>((ref) {
//   return OrderSetNotifier();
// });
// class OrderSetNotifier extends StateNotifier<List<OrderItem>> {
//   OrderSetNotifier() : super([]);
//   void clearPlaceItems(String placeId) {
//     state = state.where((item) => item.placeId != placeId).toList();
//   }
// }

class OrderController {
  final Employee employee;
  final Place place;
  final AppModel model;

  OrderController({
    required this.model,
    required this.place,
    required this.employee,
  });

  final OrderDatabase _database = OrderDatabase();

  Future<void> openOrder(
    BuildContext context,
    WidgetRef ref,
    List<OrderItem> products, {
    String? note,
    Customer? customer,
    DateTime? scheduledDate,
  }) async {
    if (!context.mounted) return;
    showAppLoadingDialog(context);

    double totalPrice = products.fold(0.0, (oldValue, element) {
      return oldValue + (element.amount * element.product.price);
    });

    Order order = Order(
      place: place,
      employee: employee,
      price: totalPrice,
      products: products,
      createdDate: DateTime.now().toIso8601String(),
      updatedDate: DateTime.now().toIso8601String(),
      customer: customer,
      note: note,
      scheduledDate: scheduledDate?.toIso8601String(),
      orderNumber: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    await _database.setPlaceOrder(data: order, placeId: place.id);

    if (!context.mounted) return;
    AppRouter.close(context);
    ref.invalidate(ordersProvider(place.id));
    ref.invalidate(ordersProvider);
    ShowToast.success(context, AppLocales.orderCreatedSuccessfully.tr());

    PrinterMultipleServices printerMultipleServices = PrinterMultipleServices();
    printerMultipleServices.printForBack(order, products);
  }

  Future<void> addItems(
    BuildContext context,
    WidgetRef ref,
    List<OrderItem> newItemsList,
    Order oldOrderState, {
    String? note,
    Customer? customer,
    DateTime? scheduledDate,
  }) async {
    if (!context.mounted) return;
    showAppLoadingDialog(context);

    Order? currentState = await _database.getPlaceOrder(place.id);
    if (currentState == null) {
      if (context.mounted) AppRouter.close(context);
      return;
    }

    Order updatedOrder = currentState.copyWith(products: List<OrderItem>.from(newItemsList));

    double totalPrice = newItemsList.fold(0.0, (oldValue, element) {
      return oldValue + (element.amount * element.product.price);
    });
    updatedOrder = updatedOrder.copyWith(price: totalPrice);

    if (customer != null) updatedOrder = updatedOrder.copyWith(customer: customer);
    if (note != null) updatedOrder = updatedOrder.copyWith(note: note);
    if (scheduledDate != null) updatedOrder = updatedOrder.copyWith(scheduledDate: scheduledDate.toIso8601String());

    updatedOrder = updatedOrder.copyWith(updatedDate: DateTime.now().toIso8601String());

    await _database.updatePlaceOrder(data: updatedOrder, placeId: place.id);

    if (!context.mounted) return;
    ref.invalidate(ordersProvider(place.id));
    ref.invalidate(ordersProvider);
    AppRouter.close(context);

    PrinterMultipleServices printerMultipleServices = PrinterMultipleServices();
    final List<OrderItem> changes = _onGetChanges(newItemsList, oldOrderState);

    log('changes: ${changes.length}');

    printerMultipleServices.printForBack(updatedOrder, changes);
  }

  static Future<Order?> getCurrentOrder(String placeId) async {
    OrderDatabase database = OrderDatabase();
    final state = await database.getPlaceOrder(placeId);
    return state;
  }

  Future<void> closeOrder(
    BuildContext context,
    WidgetRef ref, {
    String? note,
    Customer? customer,
    DateTime? scheduledDate,
    String? paymentType,
    bool useCheck = true,
  }) async {
    if (!context.mounted) return;
    showAppLoadingDialog(context);

    Order? currentOrderData = await _database.getPlaceOrder(place.id);
    Order orderToProcess;

    if (currentOrderData == null) {
      final orderItemsFromProvider = ref.read(orderSetProvider);
      final productsForNewOrder = orderItemsFromProvider.where((e) => e.placeId == place.id).toList();

      double totalPrice = productsForNewOrder.fold(0.0, (oldValue, element) {
        return oldValue + (element.amount * element.product.price);
      });

      orderToProcess = Order(
        place: place,
        employee: employee,
        price: totalPrice,
        products: productsForNewOrder,
        createdDate: DateTime.now().toIso8601String(),
        updatedDate: DateTime.now().toIso8601String(),
        orderNumber: DateTime.now().millisecondsSinceEpoch.toString(),
      );
    } else {
      orderToProcess = currentOrderData;
    }

    Order finalOrder = orderToProcess.copyWith();

    final percents = await OrderPercentDatabase().get();
    if (!place.percentNull) {
      log(place.toJson().toString());
      // log("${!place.percentNull}");
      final totalPercent = percents.map((e) => e.percent).fold(0.0, (a, b) => a + b);
      finalOrder = finalOrder.copyWith(price: finalOrder.price + (finalOrder.price * (totalPercent / 100)));
    }

    if (customer != null) finalOrder = finalOrder.copyWith(customer: customer);
    if (note != null) finalOrder = finalOrder.copyWith(note: note);
    if (scheduledDate != null) finalOrder = finalOrder.copyWith(scheduledDate: scheduledDate.toIso8601String());

    finalOrder = finalOrder.copyWith(status: Order.completed, updatedDate: DateTime.now().toIso8601String());

    await _database.saveOrder(finalOrder);
    await _onUpdateAmounts(finalOrder, ref);
    await _database.closeOrder(placeId: place.id);
    await _database.changesDatabase.set(
      data: Change(
        database: _database.getBoxName("all"),
        method: 'create',
        itemId: finalOrder.id,
      ),
    );

    if (!context.mounted) return;
    AppRouter.close(context);

    ref.invalidate(ordersProvider(place.id));
    ref.invalidate(ordersProvider);
    ref.invalidate(employeeOrdersProvider);
    final notifier = ref.read(orderSetProvider.notifier);
    notifier.clearPlaceItems(place.id);

    TransactionController transactionController = TransactionController(context: context, state: model);
    Transaction transaction = Transaction(
      value: finalOrder.price,
      order: finalOrder,
      employee: finalOrder.employee,
      paymentType: paymentType ?? Transaction.cash,
      note: AppLocales.byOrder.tr(),
    );
    transactionController.create(transaction);

    ShowToast.success(context, AppLocales.orderClosedSuccessfully.tr());

    if (!useCheck) return;

    PrinterServices printerServices = PrinterServices(order: finalOrder, model: model);
    printerServices.printOrderCheck();
  }

  Future<void> _onUpdateAmounts(Order order, ref) async {
    ProductDatabase productDatabase = ProductDatabase();
    for (final item in order.products) {
      Product product = item.product;
      if (product.amount == 1) continue;

      Product updatedProduct = product.copyWith(amount: product.amount - item.amount);
      await productDatabase.update(key: product.id, data: updatedProduct);
    }

    ref.invalidate(productsProvider);
    ref.refresh(productsProvider);
  }

  List<OrderItem> _onGetChanges(List<OrderItem> newItemsList, Order oldOrderState) {
    final List<OrderItem> changes = [];
    final Map<String, OrderItem> oldItemsMap = {for (var item in oldOrderState.products) item.product.id: item};
    final Map<String, OrderItem> newItemsMap = {for (var item in newItemsList) item.product.id: item};

    // Check for added or modified items
    for (final newItem in newItemsList) {
      final oldItem = oldItemsMap[newItem.product.id];
      if (oldItem == null) {
        // Item added
        changes.add(newItem.copyWith()); // Add full new item
      } else {
        // Item existed, check if amount changed
        if (newItem.amount != oldItem.amount) {
          changes.add(newItem.copyWith(amount: newItem.amount - oldItem.amount));
        }
      }
    }

    // Check for removed items
    for (final oldItem in oldOrderState.products) {
      if (!newItemsMap.containsKey(oldItem.product.id)) {
        // Item removed
        changes.add(oldItem.copyWith(amount: -oldItem.amount)); // Negative amount indicates removal
      }
    }
    return changes;
  }
}

// How to call from widget (example):
/*
// Inside a ConsumerWidget's build method or ConsumerStatefulWidget's State:
// final WidgetRef ref; (available)
// final BuildContext context; (available)

onCancel: () async {
  final currentEmployee = ref.watch(currentEmployeeProvider); // Or ref.read if it won't change
  if (currentEmployee == null) {
    // Handle case where employee is not available
    ShowToast.error(context, "Current employee not found.");
    return;
  }

  OrderController orderController = OrderController(
    place: place, // 'place' should be available in this scope
    employee: currentEmployee,
  );

  final localContext = context; // Capture before await
  final localRef = ref; // Capture before await

  await orderController.closeOrder(
    localContext,
    localRef,
    note: noteController.text.trim(),
    customer: customerNotifier.value,
    scheduledDate: scheduledTime.value,
  );

  if (localContext.mounted) {
    noteController.clear();
    customerNotifier.value = null;
    // scheduledTime.value = null; // Be careful if this is a ValueNotifier and widget might be disposed
  }
},
*/
