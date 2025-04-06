import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/database/order_database/order_database.dart';

final ordersProvider = FutureProvider((ref) async {
  OrderDatabase orderDatabase = OrderDatabase();
  return await orderDatabase.get();
});
