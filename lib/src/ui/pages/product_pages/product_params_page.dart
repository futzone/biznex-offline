import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/extensions/for_double.dart';
import 'package:biznex/src/ui/screens/product_info_screen/product_measure_reponsive.dart';
import 'package:biznex/src/ui/widgets/custom/app_list_tile.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';
import 'package:biznex/src/ui/widgets/helpers/app_text_field.dart';
import 'package:ionicons/ionicons.dart';
import '../../screens/product_info_screen/product_color_responsive.dart';
import '../../widgets/helpers/app_simple_button.dart';

class ProductParamsPage extends AppStatelessWidget {
  final ValueNotifier<AppBar> appbar;
  final ValueNotifier<FloatingActionButton?> floatingActionButton;

  const ProductParamsPage(this.floatingActionButton, {super.key, required this.appbar});

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
                    title: AppLocales.productColors.tr(),
                    theme: theme,
                    leadingIcon: Icons.color_lens_outlined,
                    trailingIcon: Icons.arrow_forward_ios_outlined,
                    onPressed: () {
                      showDesktopModal(
                        context: context,
                        body: ProductColorResponsive(useBack: true),
                      );
                    },
                  ),
                  AppListTile(
                    title: AppLocales.productMeasures.tr(),
                    theme: theme,
                    leadingIcon: Icons.balance,
                    trailingIcon: Icons.arrow_forward_ios_outlined,
                    onPressed: () {
                      showDesktopModal(
                        context: context,
                        body: ProductMeasureReponsive(useBack: true),
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
                  Expanded(child: ProductColorResponsive()),
                  Container(
                    height: double.infinity,
                    width: 2,
                    color: theme.accentColor,
                  ),
                  Expanded(child: ProductMeasureReponsive()),
                ],
              ),
            ),
    );
  }
}
