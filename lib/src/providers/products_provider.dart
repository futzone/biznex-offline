import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/database/product_database/product_database.dart';

final FutureProvider productsProvider = FutureProvider((ref) async {
  ProductDatabase productDatabase = ProductDatabase();
  return await productDatabase.get();
});
