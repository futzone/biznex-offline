import 'dart:developer';

import 'package:biznex/src/core/database/app_database/app_database.dart';
import 'package:biznex/src/core/database/changes_database/changes_database.dart';
import 'package:biznex/src/core/model/app_changes_model.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:uuid/uuid.dart';

class OrderDatabase {
  ChangesDatabase changesDatabase = ChangesDatabase();
  String getBoxName(id) => "orders_$id";

  Future<Box> openBox(String boxName) async {
    final box = await Hive.openBox(boxName);
    return box;
  }

  String get generateID {
    var uuid = Uuid();
    return uuid.v1();
  }

  Future<List<Order>> getOrders() async {
    final box = await openBox(getBoxName("all"));
    final boxData = box.values;
    List<Order> ordersList = [];
    for (final item in boxData) {
      ordersList.add(Order.fromJson(item));
    }

    return ordersList;
  }

  Future<void> deleteOrder(String id) async {
    final box = await openBox(getBoxName("all"));
    await box.delete(id);
  }

  Future<void> saveOrder(Order order) async {
    order.id = generateID;
    final box = await openBox(getBoxName("all"));
    box.put(order.id, order.toJson());
     await changesDatabase.set(
      data: Change(
        database: getBoxName("all"),
        method: 'create',
        itemId: order.id,
      ),
    );
  }

  Future<Order?> getPlaceOrder(String placeId) async {
    final box = await openBox(getBoxName("${placeId}_open"));
    final boxData = box.values.firstOrNull;

    return boxData == null ? null : Order.fromJson(boxData);
  }

  Future<void> deletePlaceOrder(String placeId) async {
    final box = await openBox(getBoxName("${placeId}_open"));
    await box.clear();
  }

  Future<void> setPlaceOrder({required data, required String placeId}) async {
    if (data is! Order) return;
    Order productInfo = data;
    productInfo.id = generateID;
    final box = await openBox(getBoxName("${placeId}_open"));
    await box.put(productInfo.id, productInfo.toJson());
  }

  Future<void> updatePlaceOrder({required data, required String placeId}) async {
    if (data is! Order) return;

    final box = await openBox(getBoxName("${placeId}_open"));
    final orderJson = data.toJson();

    if (orderJson.isNotEmpty) {
      await box.put(data.id, orderJson);
    }
  }

  Future<void> closeOrder({required String placeId}) async {
    final box = await openBox(getBoxName("${placeId}_open"));
    await box.clear();
  }
}
