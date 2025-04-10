import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/core/database/order_database/order_database.dart';
import 'package:biznex/src/core/database/order_database/order_percent_database.dart';
import 'package:biznex/src/core/model/employee_models/employee_model.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:biznex/src/core/model/other_models/customer_model.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
import 'package:biznex/src/core/services/printer_services.dart';
import 'package:biznex/src/providers/employee_orders_provider.dart';
import 'package:biznex/src/providers/orders_provider.dart';
import 'package:biznex/src/ui/widgets/custom/app_loading.dart';
import 'package:biznex/src/ui/widgets/custom/app_toast.dart';

class OrderController {
  final Employee employee;
  final Place place;
  final BuildContext context;
  final AppModel model;

  OrderController({
    required this.model,
    required this.context,
    required this.place,
    required this.employee,
  });

  final OrderDatabase _database = OrderDatabase();

  Future<void> openOrder(List<OrderItem> products, {String? note, Customer? customer, DateTime? scheduledDate}) async {
    showAppLoadingDialog(context);

    double totalPrice = products.fold(0, (oldValue, element) {
      return oldValue += (element.customPrice ?? (element.amount * element.product.price));
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
    );
    await _database.setPlaceOrder(data: order, placeId: place.id).then((_) {
      AppRouter.close(context);
      model.ref!.invalidate(ordersProvider(place.id));
      model.ref!.invalidate(ordersProvider);
      ShowToast.success(context, AppLocales.orderCreatedSuccessfully.tr());
    });
  }

  Future<void> addItems(List<OrderItem> items, {String? note, Customer? customer, DateTime? scheduledDate}) async {
    showAppLoadingDialog(context);
    Order? currentState = await _database.getPlaceOrder(place.id);
    if (currentState == null) return;
    currentState.products = items;
    if (customer != null) currentState.customer = customer;
    if (note != null) currentState.note = note;
    if (scheduledDate != null) currentState.scheduledDate = scheduledDate.toIso8601String();
    await _database.updatePlaceOrder(data: currentState, placeId: place.id);
    model.ref!.invalidate(ordersProvider(place.id));
    model.ref!.invalidate(ordersProvider);
    AppRouter.close(context);
  }

  Future<void> updateItems(OrderItem item) async {
    showAppLoadingDialog(context);
    Order? currentState = await _database.getPlaceOrder(place.id);
    if (currentState == null) return;
    final oldItem = currentState.products.where((element) => element.product.id == item.product.id).toList().firstOrNull;
    if (item.amount > 0) {
      if (oldItem == null) {
        currentState.products.add(item);
      } else {
        List<OrderItem> updatedList = currentState.products.map((i) {
          if (item.product.id == i.product.id) {
            return i.copyWith(amount: item.amount);
          }
          return i;
        }).toList();
        currentState.products = updatedList;
      }
    } else {
      List<OrderItem> updatedList = currentState.products.where((el) => el.product.id != item.product.id).toList();
      currentState.products = updatedList;
    }

    await _database.updatePlaceOrder(data: currentState, placeId: place.id);

    model.ref!.invalidate(ordersProvider(place.id));
    model.ref!.invalidate(ordersProvider);
    AppRouter.close(context);
  }

  static Future<Order?> getCurrentOrder(String placeId) async {
    OrderDatabase database = OrderDatabase();
    final state = await database.getPlaceOrder(placeId);

    return state;
  }

  Future<void> closeOrder({String? note, Customer? customer, DateTime? scheduledDate}) async {
    showAppLoadingDialog(context);
    Order? currentState = await _database.getPlaceOrder(place.id);
    if (currentState == null) {
      final orderItems = model.ref!.watch(orderSetProvider);
      final products = orderItems.where((e) => e.placeId == place.id).toList();

      double totalPrice = products.fold(0, (oldValue, element) {
        return oldValue += (element.customPrice ?? (element.amount * element.product.price));
      });

      currentState = Order(
        place: place,
        employee: employee,
        price: totalPrice,
        products: products,
        scheduledDate: scheduledDate?.toIso8601String(),
        createdDate: DateTime.now().toIso8601String(),
        updatedDate: DateTime.now().toIso8601String(),
      );
    }

    final percents = await OrderPercentDatabase().get();

    for (final per in percents) {
      currentState.price += (currentState.price * (0.01 * per.percent));
    }

    if (customer != null) currentState.customer = customer;
    if (note != null) currentState.note = note;
    currentState.status = Order.completed;
    await _database.saveOrder(currentState);

    await _database.closeOrder(placeId: place.id);
    model.ref!.invalidate(ordersProvider(place.id));
    model.ref!.invalidate(ordersProvider);
    model.ref!.invalidate(employeeOrdersProvider);
    final notifier = model.ref!.watch(orderSetProvider.notifier);
    notifier.clearPlaceItems(place.id);
    AppRouter.close(context);

    ShowToast.success(context, AppLocales.orderClosedSuccessfully.tr());

    PrinterServices printerServices = PrinterServices(order: currentState, model: model, ref: model.ref!);
    printerServices.printOrderCheck();
  }
}
