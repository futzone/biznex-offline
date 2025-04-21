import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/database/product_database/product_database.dart';
import 'package:biznex/src/core/model/product_models/product_model.dart';

final FutureProvider<List<Product>> productsProvider = FutureProvider<List<Product>>((ref) async {
  ProductDatabase productDatabase = ProductDatabase();
  final list = await productDatabase.get();

  list.sort((a, b) {
    final dateA = DateTime.parse(a.cratedDate ?? DateTime.now().toIso8601String());
    final dateB = DateTime.parse(b.updatedDate ?? DateTime.now().toIso8601String());
    return dateB.compareTo(dateA);
  });

  return list;
});
