import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/extensions/app_responsive.dart';
import 'package:biznex/src/core/model/category_model/category_model.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
import 'package:biznex/src/core/model/product_models/product_model.dart';
import 'package:biznex/src/providers/category_provider.dart';
import 'package:biznex/src/providers/products_provider.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:flutter_svg/svg.dart';
import '../../widgets/custom/app_toast.dart';
import '../products_screens/product_card.dart';

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

  List<Product> buildFilterResult() {
    final providerListener = ref.watch(productsProvider).value ?? [];
    if (_selectedCategory == null) return providerListener;
    return providerListener.where((e) {
      return e.category?.id == _selectedCategory?.id;
    }).toList();
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
    final providerListener = ref.watch(productsProvider).value ?? [];

    int getProductCount(ctg) {
      if (ctg == 0) return providerListener.length;
      return providerListener.where((el) => ctg == el.category?.id).length;
    }

    return AppStateWrapper(
      builder: (theme, state) {
        return Expanded(
          flex: 9,
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SingleChildScrollView(
                padding: Dis.only(lr: context.w(32), top: context.h(24)),
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
                        for (final category in categories)
                          WebButton(
                            onPressed: () {
                              if (_selectedCategory == category) {
                                _selectedCategory = null;
                              } else {
                                _selectedCategory = category;
                                _onCategorySelected(category.id);
                              }
                              setState(() {});
                            },
                            builder: (focused) => Container(
                              padding: Dis.all(context.s(12)),
                              decoration: BoxDecoration(
                                color: _selectedCategory?.id == category.id ? theme.mainColor : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: focused
                                    ? Border.all(color: theme.mainColor)
                                    : Border.all(
                                        color: _selectedCategory?.id == category.id ? theme.mainColor : Colors.white,
                                      ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: context.s(12),
                                children: [
                                  Container(
                                    height: context.s(48),
                                    width: context.s(48),
                                    padding: Dis.all(context.s(8)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: _selectedCategory?.id == category.id ? theme.white : theme.scaffoldBgColor,
                                    ),
                                    child: Center(
                                      child: category.icon == null
                                          ? Text(
                                              category.name.trim().isNotEmpty ? category.name.trim()[0] : "🍜",
                                              style: TextStyle(
                                                fontSize: context.s(24),
                                                fontFamily: boldFamily,
                                              ),
                                            )
                                          : SvgPicture.asset(
                                              category.icon ?? '',
                                              width: context.s(32),
                                              height: context.s(32),
                                              colorFilter: ColorFilter.mode(
                                                _selectedCategory?.id == category.id ? theme.mainColor : theme.secondaryTextColor,
                                                BlendMode.color,
                                              ),
                                            ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        category.name,
                                        style: TextStyle(
                                          fontSize: context.s(16),
                                          fontFamily: mediumFamily,
                                          color: _selectedCategory?.id == category.id ? Colors.white : theme.textColor,
                                        ),
                                      ),
                                      Text(
                                        "${'productCount'.tr()}: ${getProductCount(category.id)}",
                                        style: TextStyle(
                                          fontSize: context.s(14),
                                          fontFamily: regularFamily,
                                          color: _selectedCategory?.id == category.id ? Colors.white : theme.secondaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: context.w(32).lr,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocales.all_products.tr(),
                      style: TextStyle(fontFamily: mediumFamily, fontSize: 20),
                    ),
                    Text(
                      "${'productCount'.tr()}: ${providerListener.length} ${AppLocales.ta.tr()}",
                      style: TextStyle(
                        fontFamily: regularFamily,
                        fontSize: 16,
                        color: theme.secondaryTextColor,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: state.whenProviderData(
                  provider: productsProvider,
                  builder: (products) {
                    if (_searchResultList.isEmpty && _textEditingController.text.isNotEmpty) return AppEmptyWidget();

                    products as List<Product>;

                    return GridView.builder(
                      padding: Dis.only(lr: context.w(32)),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: context.s(16),
                        crossAxisSpacing: context.s(16),
                        childAspectRatio: 261 / 321,
                      ),
                      itemCount: ((_searchResultList.isNotEmpty && _textEditingController.text.isNotEmpty) || _selectedCategory != null)
                          ? _searchResultList.length
                          : products.length,
                      itemBuilder: (BuildContext context, int index) {
                        final product = buildFilterResult()[index];
                        return SimpleButton(
                          onPressed: () {
                            if (product.amount != -1) {
                              orderNotifier.addItem(OrderItem(product: product, amount: 1, placeId: widget.place.id), context);
                            } else {
                              ShowToast.error(context, AppLocales.productStockError.tr());
                            }
                          },
                          child: ProductCardNew(product: product, colors: theme),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
