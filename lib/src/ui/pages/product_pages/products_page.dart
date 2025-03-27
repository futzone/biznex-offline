import 'dart:io';
import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/product_controller.dart';
import 'package:biznex/src/core/extensions/for_double.dart';
import 'package:biznex/src/core/model/product_models/product_model.dart';
import 'package:biznex/src/providers/products_provider.dart';
import 'package:biznex/src/ui/pages/product_pages/add_product_page.dart';
import 'package:biznex/src/ui/widgets/custom/app_custom_popup_menu.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/helpers/app_custom_padding.dart';
import 'package:biznex/src/ui/widgets/helpers/app_text_field.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';

import '../../widgets/custom/app_infinity_screen.dart';
import '../../widgets/helpers/app_simple_button.dart';

class ProductsPage extends HookWidget {
  final ValueNotifier<AppBar> appbar;
  final ValueNotifier<FloatingActionButton?> floatingActionButton;

  const ProductsPage(this.floatingActionButton, {super.key, required this.appbar});

  @override
  Widget build(BuildContext context) {
    final isAddProduct = useState(false);

    return AppStateWrapper(builder: (theme, state) {
      if (isAddProduct.value) {
        return AddProductPage(
          state: state,
          theme: theme,
          onBackPressed: () => isAddProduct.value = false,
        );
      }
      return AppScaffold(
        appbar: appbar,
        state: state,
        title: AppLocales.products.tr(),
        floatingActionButton: null,
        floatingActionButtonNotifier: floatingActionButton,
        actions: [
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
          0.w,
          AppSimpleButton(
            text: AppLocales.add.tr(),
            icon: Icons.add,
            onPressed: () => isAddProduct.value = true,
          ),
        ],
        body: Padding(
          padding: 24.lr,
          child: Column(
            children: [
              Container(
                padding: Dis.only(lr: 24, tb: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: theme.sidebarBG,
                ),
                child: Row(
                  spacing: 16,
                  children: [
                    Expanded(flex: 1, child: Text(AppLocales.productImageLabel.tr(), style: TextStyle(color: Colors.white))),
                    Expanded(flex: 2, child: Center(child: Text(AppLocales.productName.tr(), style: TextStyle(color: Colors.white)))),
                    Expanded(flex: 1, child: Center(child: Text(AppLocales.currentPriceLabel.tr(), style: TextStyle(color: Colors.white)))),
                    Expanded(flex: 1, child: Center(child: Text(AppLocales.amountLabel.tr(), style: TextStyle(color: Colors.white)))),
                    Expanded(flex: 1, child: Center(child: Text(AppLocales.size.tr(), style: TextStyle(color: Colors.white)))),
                    Expanded(flex: 1, child: Center(child: Text(AppLocales.productBarcodeLabel.tr(), style: TextStyle(color: Colors.white)))),
                    Expanded(flex: 1, child: Center(child: Text(AppLocales.tagnumber.tr(), style: TextStyle(color: Colors.white)))),
                    Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text("", style: TextStyle(color: Colors.white)))),
                  ],
                ),
              ),
              Expanded(
                child: state.whenProviderData(
                  provider: productsProvider,
                  builder: (products) {
                    products as List<Product>;
                    if (products.isEmpty) return AppEmptyWidget();
                    return ListView.builder(
                      padding: Dis.only(top: 16, bottom: 24),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return Container(
                          margin: 8.tb,
                          padding: Dis.only(lr: 16, tb: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: theme.accentColor,
                          ),
                          child: Row(
                            spacing: 16,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 64,
                                    width: 64,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: theme.scaffoldBgColor,
                                      image: (product.images != null && product.images!.isNotEmpty)
                                          ? DecorationImage(image: FileImage(File(product.images!.first)), fit: BoxFit.cover)
                                          : null,
                                    ),
                                    child: !(product.images == null || product.images!.isEmpty)
                                        ? null
                                        : Center(
                                            child: Text(
                                              product.name.trim()[0],
                                              style: TextStyle(
                                                color: theme.textColor,
                                                fontSize: 24,
                                                fontFamily: boldFamily,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Expanded(flex: 2, child: Center(child: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis))),
                              Expanded(flex: 1, child: Center(child: Text(product.price.priceUZS))),
                              Expanded(flex: 1, child: Center(child: Text("${product.amount.price} ${product.measure ?? ''}"))),
                              Expanded(flex: 1, child: Center(child: Text(product.size ?? ' - '))),
                              Expanded(flex: 1, child: Center(child: Text(product.barcode ?? ' - '))),
                              Expanded(flex: 1, child: Center(child: Text(product.tagnumber ?? ' - '))),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: CustomPopupMenu(
                                    theme: theme,
                                    children: [
                                      CustomPopupItem(title: AppLocales.edit.tr(), icon: Icons.edit),
                                      CustomPopupItem(title: AppLocales.add.tr(), icon: Icons.add),
                                      CustomPopupItem(title: AppLocales.monitoring.tr(), icon: Icons.bar_chart),
                                      CustomPopupItem(title: AppLocales.showProduct.tr(), icon: Icons.visibility_outlined),
                                      CustomPopupItem(
                                        title: AppLocales.delete.tr(),
                                        icon: Icons.delete_outline,
                                        onPressed: () => ProductController.onDeleteProduct(context: context, state: state, id: product.id),
                                      ),
                                    ],
                                    child: IgnorePointer(
                                      ignoring: true,
                                      child: IconButton.outlined(
                                        onPressed: () {},
                                        icon: Icon(Icons.more_vert),
                                        color: theme.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
