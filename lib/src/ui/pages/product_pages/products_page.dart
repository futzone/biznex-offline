import 'package:barcode/barcode.dart';
import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/extensions/for_double.dart';
import 'package:biznex/src/ui/pages/product_pages/add_product_page.dart';
import 'package:biznex/src/ui/widgets/custom/app_list_tile.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/helpers/app_text_field.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';

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
        body: ListView(
          children: [
            for (int i = 0; i < 20; i++) AppListTile(title: 'Ha', theme: theme),
          ],
        ),
      );
    });
  }
}
