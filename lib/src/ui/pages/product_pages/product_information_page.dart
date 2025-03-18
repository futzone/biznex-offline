import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/product_info_controller.dart';
import 'package:biznex/src/controllers/product_size_controller.dart';
import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/core/extensions/for_double.dart';
import 'package:biznex/src/providers/product_information_provider.dart';
import 'package:biznex/src/providers/product_size_provider.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/custom/app_list_tile.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';
import 'package:biznex/src/ui/widgets/helpers/app_loading_screen.dart';
import 'package:biznex/src/ui/widgets/helpers/app_text_field.dart';
import 'package:ionicons/ionicons.dart';
import '../../screens/other_screens/header_screen.dart';
import '../../screens/product_info_screen/add_product_info.dart';
import '../../screens/product_info_screen/add_product_size.dart';
import '../../widgets/custom/app_error_screen.dart';
import '../../widgets/helpers/app_simple_button.dart';

class ProductInformationsPage extends AppStatelessWidget {
  final ValueNotifier<AppBar> appbar;
  final ValueNotifier<FloatingActionButton?> floatingActionButton;

  const ProductInformationsPage(this.floatingActionButton, {super.key, required this.appbar});

  @override
  Widget builder(BuildContext context, AppColors theme, WidgetRef ref, AppModel state) {
    return AppScaffold(
      appbar: appbar,
      state: state,
      title: AppLocales.productInformation.tr(),
      floatingActionButton: null,
      floatingActionButtonNotifier: floatingActionButton,
      actions: [
        if (state.isDesktop) 160.w,
        if (state.isDesktop)
          Expanded(
            child: AppTextField(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Ionicons.search_outline),
              ),
              suffixIcon: Padding(
                padding: 8.lr,
                child: IconButton(
                  icon: Icon(Ionicons.filter_outline),
                  onPressed: () {},
                ),
              ),
              title: AppLocales.searchBarHint.tr(),
              controller: TextEditingController(),
              theme: theme,
              enabledColor: theme.secondaryTextColor,
            ),
          ),
        if (!state.isDesktop)
          AppSimpleButton(
            text: AppLocales.search.tr(),
            icon: Icons.search,
            onPressed: () {},
          ),
      ],
      body: state.isMobile
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppListTile(
                    title: AppLocales.productInformation.tr(),
                    theme: theme,
                    leadingIcon: Icons.info_outline,
                    trailingIcon: Icons.arrow_forward_ios_outlined,
                    onPressed: () {
                      showDesktopModal(
                        context: context,
                        body: buildProductInfoScreen(context, state, theme, ref, useBack: true),
                      );
                    },
                  ),
                  AppListTile(
                    title: AppLocales.productSizes.tr(),
                    theme: theme,
                    leadingIcon: Icons.format_size,
                    trailingIcon: Icons.arrow_forward_ios_outlined,
                    onPressed: () {
                      showDesktopModal(
                        context: context,
                        body: buildProductSizeScreen(context, state, theme, ref, useBack: true),
                      );
                    },
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Row(
                spacing: 24,
                children: [
                  Expanded(child: buildProductInfoScreen(context, state, theme, ref)),
                  Container(
                    height: double.infinity,
                    width: 2,
                    color: theme.accentColor,
                  ),
                  Expanded(child: buildProductSizeScreen(context, state, theme, ref)),
                ],
              ),
            ),
    );
  }

  Widget buildProductInfoScreen(BuildContext context, AppModel state, AppColors theme, WidgetRef ref, {bool useBack = false}) {
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
                title: AppLocales.productInformation.tr(),
                onAddPressed: () => showDesktopModal(context: context, body: AddProductInfo()),
              ),
            ),
          ],
        ),
        Expanded(
          child: ref.watch(productInformationProvider).when(
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
                        title: "${info.name}: ${info.data}",
                        theme: theme,
                        onDelete: () {
                          ProductInfoController controller = ProductInfoController(context: context, state: state);
                          controller.delete(info.id);
                        },
                        onEdit: () {
                          showDesktopModal(context: context, body: AddProductInfo(productInfo: info));
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

  Widget buildProductSizeScreen(BuildContext context, AppModel state, AppColors theme, WidgetRef ref, {bool useBack = false}) {
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
                title: AppLocales.productSizes.tr(),
                onAddPressed: () => showDesktopModal(context: context, body: AddProductSize()),
              ),
            ),
          ],
        ),
        Expanded(
          child: ref.watch(productSizeProvider).when(
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
                        subtitle: info.description,
                        theme: theme,
                        onDelete: () {
                          ProductSizeController controller = ProductSizeController(context: context, state: state);
                          controller.delete(info.id);
                        },
                        onEdit: () {
                          showDesktopModal(context: context, body: AddProductSize(productSize: info));
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
