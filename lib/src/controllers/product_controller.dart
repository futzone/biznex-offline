import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/app_controller.dart';
import 'package:biznex/src/core/database/product_database/product_database.dart';
import 'package:biznex/src/core/model/product_models/product_model.dart';
import 'package:biznex/src/providers/products_provider.dart';
import 'package:biznex/src/ui/widgets/custom/app_confirm_dialog.dart';
import 'package:biznex/src/ui/widgets/custom/app_loading.dart';

class ProductController extends AppController {
  ProductController({required super.context, required super.state});

  @override
  Future<void> create(data) async {
    data as Product;
    if (data.name.isEmpty) return error(AppLocales.productNameInputError.tr());
    showAppLoadingDialog(context);
    ProductDatabase sizeDatabase = ProductDatabase();
    await sizeDatabase.set(data: data).then((_) {
      state.ref!.invalidate(productsProvider);
      closeLoading();
      closeLoading();
    });
  }

  @override
  Future<void> delete(key) async {
    showConfirmDialog(
      context: context,
      title: AppLocales.deleteProductVariantQuestion.tr(),
      onConfirm: () async {
        showAppLoadingDialog(context);
        ProductDatabase sizeDatabase = ProductDatabase();
        await sizeDatabase.delete(key: key).then((_) {
          state.ref!.invalidate(productsProvider);
          closeLoading();
        });
      },
    );
  }

  @override
  Future<void> update(data, key) async {
    data as Product;
    if (data.name.isEmpty) return error(AppLocales.productNameInputError.tr());
    showAppLoadingDialog(context);
    ProductDatabase sizeDatabase = ProductDatabase();
    await sizeDatabase.update(data: data, key: data.id).then((_) {
      state.ref!.invalidate(productsProvider);
      closeLoading();
      closeLoading();
    });
  }
}
