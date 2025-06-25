import 'dart:developer';

import 'package:biznex/src/core/database/product_database/product_database.dart';
import 'package:biznex/src/core/model/app_changes_model.dart';
import 'package:biznex/src/core/model/product_models/product_model.dart';
import 'package:biznex/src/core/network/endpoints.dart';
import 'package:biznex/src/core/network/network_base.dart';
import 'package:biznex/src/core/services/license_services.dart';

class ChangesController {
  Change change;
  ChangesController(this.change);

  final Network network = Network();
  final LicenseServices licenseServices = LicenseServices();

  Future<String> _getDeviceId() async {
    return await licenseServices.getDeviceId() ?? '';
  }

  Future<bool> saveStatus() async {
    log("save status working");
    if (change.database == ProductDatabase().boxName) {
      return await _ifProductChanges();
    }

    return false;
  }

  Future<bool> ifClientChanges() async {
    return false;
  }

  Future<bool> _ifProductChanges() async {
    if (change.method == "create") {
      ProductDatabase productDatabase = ProductDatabase();
      var product = await productDatabase.getProductById(change.itemId);
      if (product == null) return true;

      CloudProduct cloudProduct = CloudProduct(
        id: product.id,
        name: product.name,
        price: product.price,
        createdAt: product.cratedDate ?? DateTime.now().toIso8601String(),
        updatedAt: product.updatedDate ?? DateTime.now().toIso8601String(),
        oldPrice: product.price / (1 + (product.percent / 100)),
        clientId: await _getDeviceId(),
        categoryName: product.category?.name ?? 'all',
        amount: product.amount,
      );

      final response = await network.post(
        ApiEndpoints.product,
        body: cloudProduct.toJson(),
      );

      return response;
    }

    if (change.method == "update") {
      ProductDatabase productDatabase = ProductDatabase();
      var product = await productDatabase.getProductById(change.itemId);
      if (product == null) return true;
      CloudProduct cloudProduct = CloudProduct(
        id: product.id,
        name: product.name,
        price: product.price,
        createdAt: product.cratedDate ?? DateTime.now().toIso8601String(),
        updatedAt: product.updatedDate ?? DateTime.now().toIso8601String(),
        oldPrice: product.price / (1 + (product.percent / 100)),
        clientId: await _getDeviceId(),
        categoryName: product.category?.name ?? 'all',
        amount: product.amount,
      );

      final response = await network.put(
        ApiEndpoints.productOne(cloudProduct.clientId),
        body: cloudProduct.toJson(),
      );

      return response;
    }

    if (change.method == "delete") {
      ProductDatabase productDatabase = ProductDatabase();
      var product = await productDatabase.getProductById(change.itemId);
      if (product == null) return true;
      CloudProduct cloudProduct = CloudProduct(
        id: product.id,
        name: product.name,
        price: product.price,
        createdAt: product.cratedDate ?? DateTime.now().toIso8601String(),
        updatedAt: product.updatedDate ?? DateTime.now().toIso8601String(),
        oldPrice: product.price / (1 + (product.percent / 100)),
        clientId: await _getDeviceId(),
        categoryName: product.category?.name ?? 'all',
        amount: product.amount,
      );
      final response = await network.delete(
        ApiEndpoints.productOne(cloudProduct.clientId),
        body: cloudProduct.toJson(),
      );
      return response;
    }
    return false;
  }
}
