import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/database/product_database/product_database.dart';
import 'package:biznex/src/core/model/product_models/product_model.dart';

final FutureProvider<List<Product>> productsProvider = FutureProvider<List<Product>>((ref) async {
  ProductDatabase productDatabase = ProductDatabase();
  return await productDatabase.get();
});
