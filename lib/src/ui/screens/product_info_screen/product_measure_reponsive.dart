import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/product_size_controller.dart';
import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/core/extensions/for_double.dart';
import 'package:biznex/src/providers/product_measure_provider.dart';
import 'package:biznex/src/ui/screens/other_screens/header_screen.dart';
import 'package:biznex/src/ui/screens/product_info_screen/add_product_measure.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/custom/app_error_screen.dart';
import 'package:biznex/src/ui/widgets/custom/app_list_tile.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';
import 'package:biznex/src/ui/widgets/helpers/app_loading_screen.dart';
import 'package:biznex/src/ui/widgets/helpers/app_simple_button.dart';

class ProductMeasureReponsive extends AppStatelessWidget {
  final bool useBack;

  const ProductMeasureReponsive({super.key, this.useBack = false});

  @override
  Widget builder(BuildContext context, AppColors theme, WidgetRef ref, AppModel state) {
    return Column(
      children: [
        Row(
          children: [
            if (useBack)
              SimpleButton(
                child: Icon(Icons.arrow_back_ios_new),
                onPressed: () => AppRouter.close(context),
              ),
            if (useBack) 24.w,
            Expanded(
              child: HeaderScreen(
                title: AppLocales.productMeasures.tr(),
                onAddPressed: () => showDesktopModal(context: context, body: AddProductMeasure()),
              ),
            ),
          ],
        ),
        Expanded(
          child: ref.watch(productMeasureProvider).when(
                loading: () => AppLoadingScreen(),
                error: RefErrorScreen,
                data: (data) {
                  if (data.isEmpty) return AppEmptyWidget();
                  return ListView.builder(
                    padding: 8.top,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final info = data[index];
                      return AppListTile(
                        title: info.name,
                        theme: theme,
                        onDelete: () {
                          ProductSizeController controller = ProductSizeController(context: context, state: state);
                          controller.delete(info.id);
                        },
                        onEdit: () {
                          showDesktopModal(context: context, body: AddProductMeasure(productMeasure: info));
                        },
                      );
                    },
                  );
                },
              ),
        ),
      ],
    );
  }
}
