import 'package:biznex/src/core/database/app_database/app_database.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
 
class OrderDatabase extends AppDatabase {
  final String boxName = 'orders';

  @override
  Future delete({required String key}) async {
    final box = await openBox(boxName);
    await box.delete(key);
  }

  @override
  Future<List<Order>> get() async {
    final box = await openBox(boxName);
    final boxData = box.values;
    final List<Order> productInfoList = [];
    for (final item in boxData) {
      productInfoList.add(Order.fromJson(item));
    }
    return productInfoList;
  }

  @override
  Future<void> set({required data}) async {
    if (data is! Order) return;
    Order productInfo = data;
    productInfo.id = generateID;
    final box = await openBox(boxName);
    await box.put(productInfo.id, productInfo.toJson());
  }

  @override
  Future<void> update({required String key, required data}) async {
    if (data is! Order) return;
    final box = await openBox(boxName);
    box.put(key, data.toJson());
  }
}
