import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/app_controller.dart';
import 'package:biznex/src/core/database/product_database/product_database.dart';
import 'package:biznex/src/core/model/product_models/product_model.dart';
import 'package:biznex/src/providers/products_provider.dart';
import 'package:biznex/src/ui/widgets/custom/app_confirm_dialog.dart';
import 'package:biznex/src/ui/widgets/custom/app_loading.dart';

class ProductController extends AppController {
  final void Function()? onClose;

  ProductController({this.onClose, required super.context, required super.state});

  @override
  Future<void> create(data) async {
    data as Product;
    if (data.name.isEmpty) return error(AppLocales.productNameInputError.tr());
    showAppLoadingDialog(context);
    ProductDatabase sizeDatabase = ProductDatabase();
    await sizeDatabase.set(data: data).then((_) {
      state.ref!.invalidate(productsProvider);
      closeLoading();
      if (onClose != null) onClose!();
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
      if (onClose != null) onClose!();
    });
  }

  static Future<void> onDeleteProduct({required BuildContext context, required AppModel state, required dynamic id}) async {
    ProductController controller = ProductController(context: context, state: state);
    await controller.delete(id);
  }
}
