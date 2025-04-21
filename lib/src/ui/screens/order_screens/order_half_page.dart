import 'dart:io';

import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/extensions/device_type.dart';
import 'package:biznex/src/core/model/category_model/category_model.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
import 'package:biznex/src/core/model/product_models/product_model.dart';
import 'package:biznex/src/providers/category_provider.dart';
import 'package:biznex/src/providers/products_provider.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/custom/app_toast.dart';
import 'package:biznex/src/ui/widgets/helpers/app_text_field.dart';

class OrderHalfPage extends ConsumerStatefulWidget {
  final Place place;

  const OrderHalfPage(this.place, {super.key});

  @override
  ConsumerState<OrderHalfPage> createState() => _OrderHalfPageState();
}

class _OrderHalfPageState extends ConsumerState<OrderHalfPage> {
  Category? _selectedCategory;
  final TextEditingController _textEditingController = TextEditingController();
  List<Product> _searchResultList = [];

  void _onCategorySelected(String id) {
    final providerValue = ref.watch(productsProvider).value ?? [];
    if (_textEditingController.text.trim().isEmpty) {
      _searchResultList = providerValue.where((element) => element.category?.id == id).toList();
    } else {
      final char = _textEditingController.text.trim();
      _searchResultList = providerValue.where((element) {
        return ((element.name.toLowerCase().contains(char.toLowerCase())) ||
                (element.size != null && element.size!.toLowerCase().contains(char.toLowerCase()))) &&
            element.category?.id == _selectedCategory?.id;
      }).toList();
    }
    setState(() {});
  }

  void _onSearchQuery(String char) {
    final providerValue = ref.watch(productsProvider).value ?? [];
    if (_selectedCategory != null) {
      _searchResultList = providerValue.where((element) {
        return ((element.name.toLowerCase().contains(char.toLowerCase())) ||
                (element.size != null && element.size!.toLowerCase().contains(char.toLowerCase()))) &&
            element.category?.id == _selectedCategory?.id;
      }).toList();
      setState(() {});
      return;
    }

    _searchResultList = providerValue.where((element) {
      return (element.name.toLowerCase().contains(char.toLowerCase())) ||
          (element.size != null && element.size!.toLowerCase().contains(char.toLowerCase()));
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final orderNotifier = ref.read(orderSetProvider.notifier);

    return AppStateWrapper(
      builder: (theme, state) {
        return Expanded(
          child: Container(
            padding: 16.all,
            margin: Dis.only(tb: 16, right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.accentColor,
            ),
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 48,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: state.whenProviderData(
                        provider: categoryProvider,
                        builder: (categories) {
                          categories as List<Category>;
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 16,
                            children: [
                              SizedBox(
                                height: 48,
                                width: 240,
                                child: AppTextField(
                                  fillColor: theme.scaffoldBgColor,
                                  title: AppLocales.searchBarHint.tr(),
                                  controller: _textEditingController,
                                  theme: theme,
                                  prefixIcon: Icon(Ionicons.search_outline),
                                  onChanged: _onSearchQuery,
                                ),
                              ),
                              for (final category in categories)
                                SimpleButton(
                                  onPressed: () {
                                    if (_selectedCategory == category) {
                                      _selectedCategory = null;
                                    } else {
                                      _selectedCategory = category;
                                      _onCategorySelected(category.id);
                                    }
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: 48,
                                    padding: Dis.only(lr: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: _selectedCategory?.id == category.id ? theme.mainColor : theme.scaffoldBgColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        category.name,
                                        style: TextStyle(
                                          color: _selectedCategory == category ? Colors.white : theme.textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: state.whenProviderData(
                    provider: productsProvider,
                    builder: (products) {
                      if (_searchResultList.isEmpty && _textEditingController.text.isNotEmpty) return AppEmptyWidget();

                      products as List<Product>;

                      final deviceType = getDeviceType(context);

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: deviceType == DeviceType.desktop ? 1.0 : 0.8,
                          ),
                          itemCount: ((_searchResultList.isNotEmpty && _textEditingController.text.isNotEmpty) || _selectedCategory != null)
                              ? _searchResultList.length
                              : products.length,
                          itemBuilder: (BuildContext context, int index) {
                            final product = ((_selectedCategory != null || (_searchResultList.isNotEmpty && _textEditingController.text.isNotEmpty))
                                ? _searchResultList
                                : products)[index];
                            return SimpleButton(
                              onPressed: () {
                                if (product.amount != -1) {
                                  orderNotifier.addItem(OrderItem(product: product, amount: 1, placeId: widget.place.id));
                                  ShowToast.success(context, AppLocales.productAddedToSet.tr());
                                } else {
                                  ShowToast.error(context, AppLocales.productStockError.tr());
                                }
                              },
                              child: Container(
                                padding: Dis.all(12),
                                decoration: BoxDecoration(
                                  color: theme.scaffoldBgColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 8,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: theme.accentColor,
                                          image: (product.images == null || product.images!.isEmpty)
                                              ? null
                                              : DecorationImage(
                                                  image: FileImage(File(product.images!.first)),
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      spacing: 8,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.name,
                                            style: TextStyle(fontSize: 16, fontFamily: boldFamily),
                                          ),
                                        ),
                                        Text(product.size ?? '', style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                    Text(
                                      product.price.priceUZS,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
