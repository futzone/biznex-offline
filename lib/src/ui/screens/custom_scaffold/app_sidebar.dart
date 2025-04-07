import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/extensions/for_double.dart';
import 'package:biznex/src/ui/screens/settings_screen/settings_button_screen.dart';
import 'package:biznex/src/ui/widgets/helpers/app_custom_padding.dart';
import 'package:biznex/src/ui/widgets/helpers/app_simple_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSidebar extends AppStatelessWidget {
  final ValueNotifier<int> pageNotifier;

  const AppSidebar(this.pageNotifier, {super.key});

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Regular',
        ),
      ),
    );
  }

  Widget _buildSidebarItem(String name, String icon, bool selected, onPressed) {
    return WebButton(
      onPressed: onPressed,
      builder: (focused) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: 20.all,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: selected
                ? AppColors(isDark: true).mainColor
                : focused
                    ? Colors.black
                    : null,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                color: Colors.white,
                height: 24,
                width: 24,
              ),
              12.w,
              Text(name, style: const TextStyle(color: Colors.white)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget builder(context, theme, ref, state) {
    Widget sidebarItemBuilder(String icon, String name, int page) {
      final selected = (page == pageNotifier.value);

      return _buildSidebarItem(name, icon, selected, () => pageNotifier.value = page);
    }

    return Container(
      color: theme.sidebarBG,
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "BIZNEX",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: Dis.only(bottom: 16, top: 16),
            color: theme.accentColor,
            height: 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: Dis.only(lr: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildSectionTitle(AppLocales.mainMenu.tr()),
                  sidebarItemBuilder("assets/icons/pie.svg", AppLocales.overview.tr(), 0),
                  sidebarItemBuilder("assets/icons/shopping.svg", AppLocales.set.tr(), 1),
                  sidebarItemBuilder("assets/icons/shopping-bag.svg", AppLocales.orders.tr(), 2),
                  sidebarItemBuilder("assets/icons/category.svg", AppLocales.categories.tr(), 3),
                  // sidebarItemBuilder("assets/icons/verified.svg", AppLocales.promos.tr(), 3),
                  sidebarItemBuilder("assets/icons/dining-table.svg", AppLocales.places.tr(), 10),
                  _buildSectionTitle(AppLocales.inventory.tr()),
                  sidebarItemBuilder("assets/icons/product.svg", AppLocales.products.tr(), 4),
                  sidebarItemBuilder("assets/icons/icons8-info.svg", AppLocales.productInformation.tr(), 5),
                  sidebarItemBuilder("assets/icons/filter.svg", AppLocales.productParams.tr(), 6),
                  // sidebarItemBuilder("assets/icons/hanger.svg", AppLocales.productSizes.tr(), 6),
                  _buildSectionTitle(AppLocales.reports.tr()),
                  sidebarItemBuilder("assets/icons/reprots.svg", AppLocales.reports.tr(), 7),
                  _buildSectionTitle(AppLocales.settings.tr()),
                  sidebarItemBuilder("assets/icons/users.svg", AppLocales.employees.tr(), 8),
                  sidebarItemBuilder("assets/icons/printer-svgrepo-com.svg", AppLocales.printing.tr(), 9),
                  // sidebarItemBuilder("assets/icons/bank.svg", AppLocales.bankAccount.tr(), 9),
                  // sidebarItemBuilder("assets/icons/delivery.svg", AppLocales.delivery.tr(), 10),
                ],
              ),
            ),
          ),
          // 24.w,
          SettingsButtonScreen(theme: theme),
        ],
      ),
    );
  }
}
