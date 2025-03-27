import 'dart:developer';

import 'package:biznex/src/core/database/app_database/app_database.dart';
import 'package:biznex/src/core/model/product_models/product_model.dart';
import 'package:biznex/src/core/utils/product_utils.dart';

class ProductDatabase extends AppDatabase {
  final String boxName = 'products';

  @override
  Future delete({required String key}) async {
    final box = await openBox(boxName);
    await box.delete(key);
  }

  @override
  Future<List<Product>> get() async {
    final box = await openBox(boxName);
    final boxData = box.values;

    Map<String, Product> productMap = {};

    for (var prod in boxData) {
      productMap[prod['id']] = Product.fromJson(prod);
    }

    List<Product> rootCategories = [];

    for (var prod in productMap.values) {
      if (prod.productId == null) {
        rootCategories.add(prod);
      } else {
        var parent = productMap[prod.productId];
        if (parent != null) {
          parent.variants ??= [];
          parent.variants!.add(prod);
        }
      }
    }

    return rootCategories;
  }

  @override
  Future<void> set({required data}) async {
    if (data is! Product) return;

    Product productInfo = data;
    productInfo.id = generateID;

    if (productInfo.barcode == null || productInfo.barcode!.isEmpty) {
      productInfo.barcode = ProductUtils.generateBarcode();
    }

    if (productInfo.tagnumber == null || productInfo.tagnumber!.isEmpty) {
      productInfo.tagnumber = ProductUtils.newTagnumber;
    }

    final box = await openBox(boxName);
    await box.put(productInfo.id, productInfo.toJson());
    log("${productInfo.toJson()}");
  }

  @override
  Future<void> update({required String key, required data}) async {
    if (data is! Product) return;

    final box = await openBox(boxName);
    box.put(key, data.toJson());
  }

  Future<List<Product>> getAll() async {
    final box = await openBox(boxName);
    final boxData = box.values;

    final List<Product> productInfoList = [];
    for (final item in boxData) {
      productInfoList.add(Product.fromJson(item));
    }

    return productInfoList;
  }
}
