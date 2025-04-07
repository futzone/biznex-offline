import 'dart:developer';

import 'package:biznex/src/core/database/app_database/app_database.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:uuid/uuid.dart';

class OrderDatabase {
  String getBoxName(id) => "orders_$id";

  Future<Box> openBox(String boxName) async {
    final box = await Hive.openBox(boxName);
    return box;
  }

  String get generateID {
    var uuid = Uuid();
    return uuid.v1();
  }

  Future delete({required String key, required String placeId}) async {
    final box = await openBox(getBoxName(placeId));
    await box.delete(key);
  }

  Future<List<Order>> get(String placeId) async {
    final box = await openBox(getBoxName(placeId));
    final boxData = box.values;
    final List<Order> productInfoList = [];
    for (final item in boxData) {
      log(item.toString());
      productInfoList.add(Order.fromJson(item));
    }
    return productInfoList;
  }

  Future<void> set({required data, required String placeId}) async {
    if (data is! Order) return;
    Order productInfo = data;
    productInfo.id = generateID;
    final box = await openBox(getBoxName(placeId));
    await box.put(productInfo.id, productInfo.toJson());
  }

  Future<void> update({required data, required String placeId}) async {
    if (data is! Order) return;
    final box = await openBox(getBoxName(placeId));
    box.put(data.id, data.toJson());
  }

  Future<Order?> getPlaceOrder(String placeId) async {
    final box = await openBox(getBoxName("${placeId}_open"));
    final boxData = box.values.firstOrNull;

    return boxData == null ? null : Order.fromJson(boxData);
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
    box.put(data.id, data.toJson());
  }

  Future<void> closeOrder({required String placeId}) async {
    final box = await openBox(getBoxName("${placeId}_open"));
    await box.clear();
  }
}
