import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/app_controller.dart';
import 'package:biznex/src/core/database/order_database/order_database.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:biznex/src/providers/orders_provider.dart';
import 'package:biznex/src/ui/widgets/custom/app_confirm_dialog.dart';
import 'package:biznex/src/ui/widgets/custom/app_loading.dart';

class OrderController extends AppController {
  OrderController({required super.context, required super.state});

  @override
  Future<void> create(data) async {
    data as Order;
    showAppLoadingDialog(context);
    OrderDatabase sizeDatabase = OrderDatabase();
    await sizeDatabase.set(data: data).then((_) {
      state.ref!.invalidate(ordersProvider);
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
        OrderDatabase sizeDatabase = OrderDatabase();
        await sizeDatabase.delete(key: key).then((_) {
          state.ref!.invalidate(ordersProvider);
          closeLoading();
        });
      },
    );
  }

  @override
  Future<void> update(data, key) async {
    data as Order;
    showAppLoadingDialog(context);
    OrderDatabase sizeDatabase = OrderDatabase();
    await sizeDatabase.update(data: data, key: data.id).then((_) {
      state.ref!.invalidate(ordersProvider);
      closeLoading();
      closeLoading();
    });
  }
}
