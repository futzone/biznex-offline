import 'package:biznex/biznex.dart';
import 'package:biznex/src/ui/screens/settings_screen/settings_button_screen.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:window_manager/window_manager.dart';

class AppSidebar extends HookConsumerWidget {
  final ValueNotifier<int> pageNotifier;

  const AppSidebar(this.pageNotifier, {super.key});

  Widget _buildSidebarItem(String name, dynamic icon, bool selected, onPressed, bool opened) {
    return WebButton(
      onPressed: onPressed,
      builder: (focused) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: 20.all,
          height: 60,
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
                    if (icon is String)
                      SvgPicture.asset(
                        icon,
                        height: 24,
                        width: 24,
                        color: selected ? Colors.white : Colors.white70,
                      )
                    else
                      Icon(
                        icon,
                        color: selected ? Colors.white : Colors.white70,
                      ),
                    12.w,
                    Text(name, style: const TextStyle(color: Colors.white)),
                  ],
                )
              : (icon is String)
                  ? SvgPicture.asset(
                      icon,
                      height: 24,
                      width: 24,
                      color: selected ? Colors.white : Colors.white70,
                    )
                  : Icon(
                      icon,
                      color: selected ? Colors.white : Colors.white70,
                    ),
        );
      },
    );
  }

  @override
  Widget build(context, ref) {
    final openedValue = useState(true);

    Widget sidebarItemBuilder(dynamic icon, String name, int page) {
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
                      padding: const EdgeInsets.only(top: 36),
                      child: Icon(
                        Iconsax.menu_1,
                        color: Colors.white,
                        size: 32,
                      ),
                    )
                  : Padding(
                      padding: Dis.only(top: 36, left: 24, right: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (openedValue.value) SvgPicture.asset("assets/icons/logo-text.svg", color: theme.mainColor),
                          if (openedValue.value)
                            Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
            56.h,
            Expanded(
              child: SingleChildScrollView(
                padding: Dis.only(lr: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // sidebarItemBuilder("assets/icons/pie.svg", AppLocales.overview.tr(), 0),
                    // sidebarItemBuilder("assets/icons/shopping.svg", AppLocales.set.tr(), 1),
                    sidebarItemBuilder(Iconsax.bag, AppLocales.orders.tr(), 2),
                    sidebarItemBuilder(Iconsax.card, AppLocales.transactions.tr(), 9),
                    sidebarItemBuilder(Iconsax.reserve, AppLocales.products.tr(), 4),
                    sidebarItemBuilder(Iconsax.grid_3, AppLocales.categories.tr(), 3),
                    // sidebarItemBuilder("assets/icons/verified.svg", AppLocales.promos.tr(), 3),
                    sidebarItemBuilder("assets/icons/dining-table.svg", AppLocales.places.tr(), 10),
                    // sidebarItemBuilder(Iconsax.info_circle, AppLocales.productInformation.tr(), 5),
                    sidebarItemBuilder(Iconsax.setting_4, AppLocales.productParams.tr(), 6),
                    // sidebarItemBuilder("assets/icons/hanger.svg", AppLocales.productSizes.tr(), 6),
                    sidebarItemBuilder(Iconsax.chart_square, AppLocales.reports.tr(), 7),
                    sidebarItemBuilder(Iconsax.profile_2user, AppLocales.employees.tr(), 8),
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
