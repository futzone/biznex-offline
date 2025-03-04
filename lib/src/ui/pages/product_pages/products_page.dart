import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/extensions/for_double.dart';
import 'package:biznex/src/ui/widgets/custom/app_list_tile.dart';
import 'package:biznex/src/ui/widgets/helpers/app_text_field.dart';
import 'package:ionicons/ionicons.dart';

import '../../widgets/helpers/app_simple_button.dart';

class ProductsPage extends AppStatelessWidget {
  final ValueNotifier<AppBar> appbar;
  final ValueNotifier<FloatingActionButton?> floatingActionButton;

  const ProductsPage(this.floatingActionButton, {super.key, required this.appbar});

  @override
  Widget builder(BuildContext context, AppColors theme, WidgetRef ref, AppModel state) {
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
          onPressed: () {},
        ),
      ],
      body: ListView(
        children: [for (int i = 0; i < 20; i++) AppListTile(title: "title", theme: theme)],
      ),
    );
  }
}
