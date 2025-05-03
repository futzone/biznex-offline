import 'package:biznex/biznex.dart';
import 'package:biznex/src/ui/screens/settings_screen/settings_button_screen.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:window_manager/window_manager.dart';

class AppSidebar extends HookConsumerWidget {
  final ValueNotifier<int> pageNotifier;

  const AppSidebar(this.pageNotifier, {super.key});

  Widget _buildSidebarItem(String name, String icon, bool selected, onPressed, bool opened) {
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
          child: opened
              ? Row(
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
                )
              : SvgPicture.asset(
                  icon,
                  color: Colors.white,
                  height: 24,
                  width: 24,
                ),
        );
      },
    );
  }

  @override
  Widget build(context, ref) {
    final openedValue = useState(true);

    Widget sidebarItemBuilder(String icon, String name, int page) {
      final selected = (page == pageNotifier.value);

      return _buildSidebarItem(
        name,
        icon,
        selected,
        () {
          if (page == -1) return;
          pageNotifier.value = page;
        },
        openedValue.value,
      );
    }

    return AppStateWrapper(builder: (theme, state) {
      return Container(
        color: theme.sidebarBG,
        width: openedValue.value ? 320 : 96,
        child: Column(
          crossAxisAlignment: openedValue.value ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          mainAxisAlignment: openedValue.value ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            SimpleButton(
              onPressed: () {
                openedValue.value = !openedValue.value;
              },
              child: !openedValue.value
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Icon(
                        Ionicons.menu_outline,
                        size: 32,
                        color: Colors.white,
                      ),
                    )
                  : Padding(
                      padding: Dis.only(top: 16, left: 24, right: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (openedValue.value)
                            Text(
                              "BIZNEX",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          if (openedValue.value)
                            Center(child: Icon(Icons.arrow_back_ios, color: Colors.white))
                          else
                            Center(child: Icon(Icons.arrow_forward_ios_outlined, color: Colors.white))
                        ],
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
                    // sidebarItemBuilder("assets/icons/pie.svg", AppLocales.overview.tr(), 0),
                    // sidebarItemBuilder("assets/icons/shopping.svg", AppLocales.set.tr(), 1),
                    sidebarItemBuilder("assets/icons/shopping-bag.svg", AppLocales.orders.tr(), 2),
                    sidebarItemBuilder("assets/icons/bank.svg", AppLocales.transactions.tr(), 9),
                    sidebarItemBuilder("assets/icons/product.svg", AppLocales.products.tr(), 4),
                    sidebarItemBuilder("assets/icons/category.svg", AppLocales.categories.tr(), 3),
                    // sidebarItemBuilder("assets/icons/verified.svg", AppLocales.promos.tr(), 3),
                    sidebarItemBuilder("assets/icons/dining-table.svg", AppLocales.places.tr(), 10),
                    sidebarItemBuilder("assets/icons/icons8-info.svg", AppLocales.productInformation.tr(), 5),
                    sidebarItemBuilder("assets/icons/filter.svg", AppLocales.productParams.tr(), 6),
                    // sidebarItemBuilder("assets/icons/hanger.svg", AppLocales.productSizes.tr(), 6),
                    sidebarItemBuilder("assets/icons/reprots.svg", AppLocales.reports.tr(), 7),
                    sidebarItemBuilder("assets/icons/users.svg", AppLocales.employees.tr(), 8),
                    SimpleButton(
                      onPressed: () async {
                        final isFullscreen = await windowManager.isFullScreen();
                        await windowManager.setFullScreen(!isFullscreen);
                      },
                      child: IgnorePointer(
                        ignoring: true,
                        child: sidebarItemBuilder("assets/icons/fullscreen.svg", AppLocales.fullScreen.tr(), -1),
                      ),
                    ),
                    // sidebarItemBuilder("assets/icons/printer-svgrepo-com.svg", AppLocales.printing.tr(), 9),
                    // sidebarItemBuilder("assets/icons/delivery.svg", AppLocales.delivery.tr(), 10),
                  ],
                ),
              ),
            ),
            // 24.w,
            SettingsButtonScreen(theme: theme, model: state, opened: openedValue.value),
          ],
        ),
      );
    });
  }
}
