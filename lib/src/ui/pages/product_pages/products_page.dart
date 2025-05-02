import 'dart:io';
import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/product_controller.dart';
import 'package:biznex/src/core/model/product_models/product_model.dart';
import 'package:biznex/src/providers/products_provider.dart';
import 'package:biznex/src/ui/pages/product_pages/add_product_page.dart';
import 'package:biznex/src/ui/screens/products_screens/product_card_screen.dart';
import 'package:biznex/src/ui/screens/products_screens/products_table_header.dart';
import 'package:biznex/src/ui/widgets/custom/app_custom_popup_menu.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';
import 'package:biznex/src/ui/widgets/helpers/app_text_field.dart';
import '../../screens/products_screens/product_screen.dart';

class ProductsPage extends HookConsumerWidget {
  final ValueNotifier<AppBar> appbar;
  final ValueNotifier<FloatingActionButton?> floatingActionButton;

  const ProductsPage(this.floatingActionButton, {super.key, required this.appbar});

  @override
  Widget build(BuildContext context, ref) {
    final filterList = useState([]);
    final isAddProduct = useState(false);
    final isUpdateProduct = useState(false);
    final currentProduct = useState<Product?>(null);
    final searchController = useTextEditingController();
    final searchResultList = useState(<Product>[]);
    final filterResultList = useState(<Product>[]);

    void onSearchChanges(String char) {
      final providerListener = ref.watch(productsProvider).value ?? [];
      searchResultList.value = providerListener.where((item) {
        return item.name.toLowerCase().contains(char.toLowerCase());
      }).toList();
    }

    void onFilterChanged(String filter) {
      if (filter.isEmpty) {
        filterList.value = [];
        filterResultList.value = [];
        return;
      }

      // Filterni toggle qilish (bor bo‘lsa olib tashla, yo‘q bo‘lsa qo‘sh)
      if (filterList.value.contains(filter)) {
        filterList.value.remove(filter);
      } else {
        filterList.value.add(filter);
      }

      final products = ref.watch(productsProvider).value ?? [];

      List<Product> sorted = List.from(products);

      if (filterList.value.contains("price")) {
        sorted.sort((a, b) => b.price.compareTo(a.price));
      }

      if (filterList.value.contains("updated")) {
        sorted.sort((a, b) {
          final dateA = DateTime.tryParse(a.updatedDate ?? '') ?? DateTime(2025);
          final dateB = DateTime.tryParse(b.updatedDate ?? '') ?? DateTime(2025);
          return dateB.compareTo(dateA);
        });
      }

      if (filterList.value.contains("created")) {
        sorted.sort((a, b) {
          final dateA = DateTime.tryParse(a.cratedDate ?? '') ?? DateTime(2025);
          final dateB = DateTime.tryParse(b.cratedDate ?? '') ?? DateTime(2025);
          return dateB.compareTo(dateA);
        });
      }

      if (filterList.value.contains("amount")) {
        sorted.sort((a, b) => b.amount.compareTo(a.amount));
      }

      filterResultList.value = sorted;
    }


    return AppStateWrapper(builder: (theme, state) {
      if (isAddProduct.value) {
        return AddProductPage(
          state: state,
          theme: theme,
          onBackPressed: () => isAddProduct.value = false,
        );
      }

      if (isUpdateProduct.value) {
        return AddProductPage(
          product: currentProduct.value,
          state: state,
          theme: theme,
          onBackPressed: () {
            currentProduct.value = null;
            isUpdateProduct.value = false;
          },
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
                  child: CustomPopupMenu(
                    theme: theme,
                    children: [
                      CustomPopupItem(
                        title: AppLocales.all.tr(),
                        icon: Ionicons.list_outline,
                        onPressed: () => onFilterChanged(''),
                        iconColor: filterList.value.isEmpty ? Colors.green : null,
                      ),
                      CustomPopupItem(
                        onPressed: () => onFilterChanged('price'),
                        title: AppLocales.priceFilterText.tr(),
                        icon: Ionicons.logo_usd,
                        iconColor: filterList.value.contains('price') ? Colors.green : null,
                      ),
                      CustomPopupItem(
                        onPressed: () => onFilterChanged('amount'),
                        title: AppLocales.amountFilterText.tr(),
                        icon: Icons.storefront_outlined,
                        iconColor: filterList.value.contains('amount') ? Colors.green : null,
                      ),
                      CustomPopupItem(
                        onPressed: () => onFilterChanged('created'),
                        title: AppLocales.createdDateFilter.tr(),
                        icon: Icons.calendar_month,
                        iconColor: filterList.value.contains('created') ? Colors.green : null,
                      ),
                      CustomPopupItem(
                        title: AppLocales.updatedDateFilter.tr(),
                        icon: Icons.calendar_month,
                        onPressed: () => onFilterChanged('updated'),
                        iconColor: filterList.value.contains('updated') ? Colors.green : null,
                      ),
                    ],
                    child: Icon(Ionicons.filter_outline),
                  ),
                ),
                onChanged: onSearchChanges,
                title: AppLocales.searchBarHint.tr(),
                controller: searchController,
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
              ProductsTableHeader(),
              Expanded(
                child: state.whenProviderData(
                  provider: productsProvider,
                  builder: (products) {
                    if (searchResultList.value.isEmpty && searchController.text.isNotEmpty) {
                      return AppEmptyWidget();
                    }

                    if (filterResultList.value.isEmpty && filterList.value.isNotEmpty) {
                      return AppEmptyWidget();
                    }

                    if (filterResultList.value.isNotEmpty && filterList.value.isNotEmpty) {
                      return ListView.builder(
                        padding: Dis.only(top: 16, bottom: 24),
                        itemCount: filterResultList.value.length,
                        itemBuilder: (context, index) {
                          Product product = filterResultList.value[index];

                          return ProductCardScreen(
                            theme: theme,
                            state: state,
                            product: product,
                            onPressedEdit: () async {
                              currentProduct.value = product;
                              await Future.delayed(Duration(milliseconds: 100));
                              isUpdateProduct.value = true;
                            },
                          );
                        },
                      );
                    }

                    products as List<Product>;
                    if (products.isEmpty) return AppEmptyWidget();
                    return ListView.builder(
                      padding: Dis.only(top: 16, bottom: 24),
                      itemCount: searchResultList.value.isNotEmpty ? searchResultList.value.length : products.length,
                      itemBuilder: (context, index) {
                        Product product = searchResultList.value.isNotEmpty ? searchResultList.value[index] : products[index];

                        return ProductCardScreen(
                          theme: theme,
                          state: state,
                          product: product,
                          onPressedEdit: () async {
                            currentProduct.value = product;
                            await Future.delayed(Duration(milliseconds: 100));
                            isUpdateProduct.value = true;
                          },
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
