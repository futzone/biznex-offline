import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/core/extensions/app_responsive.dart';
import 'package:biznex/src/core/extensions/for_string.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
import 'package:biznex/src/providers/employee_provider.dart';
import 'package:biznex/src/providers/orders_provider.dart';
import 'package:biznex/src/providers/places_provider.dart';
import 'package:biznex/src/ui/pages/login_pages/onboard_page.dart';
import 'package:biznex/src/ui/pages/main_pages/main_page.dart';
import 'package:biznex/src/ui/pages/order_pages/menu_page.dart';
import 'package:biznex/src/ui/screens/settings_screen/employee_settings_screen.dart';
import 'package:biznex/src/ui/widgets/custom/app_custom_popup_menu.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/custom/app_toast.dart';
import 'package:biznex/src/ui/widgets/helpers/app_decorated_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../biznex.dart';
import '../../../core/model/order_models/order_model.dart';
import '../../widgets/dialogs/app_custom_dialog.dart';
import '../../widgets/helpers/app_back_button.dart';
import 'employee_orders_page.dart';

class TableChooseScreen extends HookConsumerWidget {
  const TableChooseScreen({super.key});

  Widget _buildHorCursi(BuildContext context) {
    return Container(
      height: context.h(12),
      width: context.w(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors(isDark: false).secondaryTextColor.withValues(alpha: 0.4), width: 2),
      ),
    );
  }

  Widget _buildVerCursi(BuildContext context) {
    return Container(
      height: context.h(30),
      width: context.w(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors(isDark: false).secondaryTextColor.withValues(alpha: 0.4), width: 2),
      ),
    );
  }

  Widget _buildTable(
      {required AppColors theme, required String name, required String status, required BuildContext context}) {
    final cColor = status == 'free' ? theme.mainColor.withValues(alpha: 0.8) : theme.secondaryTextColor;
    final textColor = status == 'free' ? theme.mainColor : theme.textColor;

    return Column(
      spacing: context.h(12),
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHorCursi(context),
        Expanded(
          child: Row(
            spacing: context.w(12),
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildVerCursi(context),
              Expanded(
                child: Container(
                  padding: context.s(20).all,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: cColor,
                    border: Border.all(color: theme.secondaryTextColor.withValues(alpha: 0.4)),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Center(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: context.s(20),
                          color: textColor,
                          fontFamily: mediumFamily,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              _buildVerCursi(context),
            ],
          ),
        ),
        _buildHorCursi(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employee = ref.watch(currentEmployeeProvider);
    final selectedPlace = useState<Place?>(null);
    final fatherPlace = useState<Place?>(null);
    return AppStateWrapper(
      builder: (theme, state) {
        return Scaffold(
          body: state.whenProviderData(
            provider: placesProvider,
            builder: (places) {
              places as List<Place>;
              if (places.isEmpty) {
                return Column(
                  children: [
                    Padding(
                      padding: 32.all,
                      child: Row(
                        children: [
                          AppBackButton(
                            onPressed: () {
                              AppRouter.open(context, OnboardPage());
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: AppEmptyWidget()),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    padding: Dis.only(lr: context.w(32), tb: context.h(24)),
                    child: Row(
                      spacing: context.w(16),
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppBackButton(
                          onPressed: () {
                            if (ref.watch(currentEmployeeProvider).roleName.toLowerCase() == 'admin') {
                              AppRouter.open(context, MainPage());
                              return;
                            }
                            AppRouter.open(context, OnboardPage());
                          },
                        ),
                        0.w,
                        SvgPicture.asset(
                          'assets/images/Vector.svg',
                          height: context.h(36),
                        ),
                        Spacer(),
                        WebButton(
                          onPressed: () {
                            ref.invalidate(ordersProvider);
                            ref.invalidate(ordersProvider(selectedPlace.value?.id ?? ""));
                            ref.invalidate(ordersProvider(fatherPlace.value?.id ?? ""));
                          },
                          builder: (focused) {
                            return Container(
                              height: context.s(48),
                              width: context.s(48),
                              decoration: BoxDecoration(
                                color: focused ? theme.mainColor.withValues(alpha: 0.1) : null,
                                borderRadius: BorderRadius.circular(48),
                                border: Border.all(color: theme.secondaryTextColor),
                              ),
                              child: Icon(Ionicons.refresh, size: context.s(24)),
                            );
                          },
                        ),
                        WebButton(
                          onPressed: () {
                            showDesktopModal(
                              context: context,
                              body: EmployeeOrdersPage(),
                              width: MediaQuery.of(context).size.width * 0.8,
                            );
                          },
                          builder: (focused) {
                            return Container(
                              height: context.s(48),
                              width: context.s(48),
                              decoration: BoxDecoration(
                                color: focused ? theme.mainColor.withValues(alpha: 0.1) : null,
                                borderRadius: BorderRadius.circular(48),
                                border: Border.all(color: theme.secondaryTextColor),
                              ),
                              child: Icon(Ionicons.list_outline, size: context.s(24)),
                            );
                          },
                        ),
                        WebButton(
                          onPressed: () {
                            showDesktopModal(context: context, body: EmployeeSettingsScreen());
                          },
                          builder: (focused) {
                            return Container(
                              height: context.s(48),
                              width: context.s(48),
                              decoration: BoxDecoration(
                                color: focused ? theme.mainColor.withValues(alpha: 0.1) : null,
                                borderRadius: BorderRadius.circular(48),
                                border: Border.all(color: theme.mainColor),
                              ),
                              child: Center(
                                child: Text(
                                  employee.fullname.initials,
                                  style: TextStyle(
                                    fontSize: context.s(20),
                                    fontFamily: boldFamily,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: theme.scaffoldBgColor,
                    padding: Dis.only(lr: context.w(32), tb: context.h(24)),
                    child: Row(
                      spacing: context.w(16),
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocales.choosePlace.tr(),
                          style: TextStyle(
                            fontFamily: mediumFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: context.s(24),
                          ),
                        ),
                        Row(
                          spacing: context.w(16),
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                color: Colors.white,
                              ),
                              padding: context.s(12).all,
                              child: Row(
                                spacing: context.w(12),
                                children: [
                                  Icon(Icons.circle, color: theme.mainColor, size: context.s(16)),
                                  Text(
                                    AppLocales.freeTables.tr(),
                                    style: TextStyle(
                                      fontSize: context.s(16),
                                      fontFamily: mediumFamily,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                color: Colors.white,
                              ),
                              padding: context.s(12).all,
                              child: Row(
                                spacing: context.w(8),
                                children: [
                                  Icon(Icons.circle, color: theme.secondaryTextColor, size: context.s(16)),
                                  Text(
                                    AppLocales.bronTables.tr(),
                                    style: TextStyle(
                                      fontSize: context.s(16),
                                      fontFamily: mediumFamily,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(99),
                            //     color: Colors.white,
                            //   ),
                            //   padding: 12.all,
                            //   child: Row(
                            //     spacing: 8,
                            //     children: [
                            //       Icon(Icons.circle, color: Colors.blue, size: 16),
                            //       Text(
                            //         AppLocales.bandTables.tr(),
                            //         style: TextStyle(
                            //           fontSize: 16,
                            //           fontFamily: mediumFamily,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                        Row(
                          spacing: context.w(16),
                          children: [
                            CustomPopupMenu(
                              theme: theme,
                              children: [
                                CustomPopupItem(
                                    title: AppLocales.all.tr(),
                                    onPressed: () => selectedPlace.value = null,
                                    icon: Icons.list),
                                for (final item in places)
                                  CustomPopupItem(
                                      title: item.name,
                                      onPressed: () => selectedPlace.value = item,
                                      icon: Icons.present_to_all),
                              ],
                              child: Container(
                                height: context.h(52),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: theme.secondaryTextColor.withValues(alpha: 0.4)),
                                ),
                                padding: Dis.only(lr: context.w(14), tb: context.h(8)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: context.w(8),
                                  children: [
                                    Text(
                                      selectedPlace.value == null
                                          ? AppLocales.choosePlace.tr()
                                          : selectedPlace.value!.name,
                                      style: TextStyle(fontSize: context.s(16), fontFamily: mediumFamily),
                                    ),
                                    Icon(Iconsax.arrow_down_1_copy, size: context.s(20)),
                                  ],
                                ),
                              ),
                            ),
                            // CustomPopupMenu(
                            //   theme: theme,
                            //   children: [
                            //     CustomPopupItem(
                            //         title: AppLocales.all.tr(), onPressed: () => selectedFilter.value = null, icon: Ionicons.list_outline),
                            //     CustomPopupItem(
                            //         title: AppLocales.freeTables.tr(),
                            //         onPressed: () {
                            //           selectedFilter.value = AppLocales.freeTables;
                            //           if (selectedPlace.value != null && selectedPlace.value?.children != null) {
                            //             filteredPlaces.value = selectedPlace.value.children.where((el)=> ).toList();
                            //           }
                            //         }),
                            //     CustomPopupItem(
                            //       title: AppLocales.bronTables.tr(),
                            //     ),
                            //   ],
                            //   child: Container(
                            //     height: context.h(52),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(8),
                            //       color: Colors.white,
                            //       border: Border.all(color: theme.secondaryTextColor.withValues(alpha: 0.4)),
                            //     ),
                            //     padding: Dis.only(lr: context.w(14), tb: context.h(8)),
                            //     child: Row(
                            //       crossAxisAlignment: CrossAxisAlignment.center,
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       spacing: 8,
                            //       children: [
                            //         Text(
                            //           AppLocales.all.tr(),
                            //           style: TextStyle(fontSize: 16, fontFamily: mediumFamily),
                            //         ),
                            //         Icon(Iconsax.arrow_down_1_copy, size: 20),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: Dis.only(lr: context.w(40)),
                      margin: Dis.only(lr: context.w(32)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        border: Border.all(color: theme.secondaryTextColor.withValues(alpha: 0.4)),
                        color: Colors.white,
                      ),
                      child: GridView.builder(
                        padding: Dis.only(tb: context.h(40)),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: context.s(80),
                          crossAxisSpacing: context.s(80),
                          childAspectRatio: 1.25,
                        ),
                        itemCount: selectedPlace.value == null
                            ? places.length
                            : selectedPlace.value?.children == null
                                ? 0
                                : selectedPlace.value?.children?.length,
                        itemBuilder: (context, index) {
                          final place = selectedPlace.value == null
                              ? places[index]
                              : selectedPlace.value?.children == null
                                  ? null
                                  : selectedPlace.value?.children![index];

                          return state.whenProviderData(
                            provider: ordersProvider(place?.id ?? ''),
                            builder: (order) {
                              order as Order?;
                              return SimpleButton(
                                onPressed: () {
                                  if (order != null &&
                                      order.employee.id != employee.id &&
                                      employee.roleName.toLowerCase() != 'admin') {
                                    ShowToast.error(context, AppLocales.otherEmployeeOrder.tr());
                                    return;
                                  }
                                  selectedPlace.value = place;

                                  if (place == null) {
                                    Place kPlace = places[index];
                                    kPlace.father = fatherPlace.value;
                                    AppRouter.go(context, MenuPage(place: kPlace, fatherPlace: fatherPlace.value));
                                    return;
                                  }

                                  if (place.children == null || place.children!.isEmpty) {
                                    Place kPlace = place;
                                    kPlace.father = fatherPlace.value;

                                    AppRouter.go(
                                      context,
                                      MenuPage(place: kPlace, fatherPlace: fatherPlace.value),
                                    );
                                    return;
                                  }

                                  fatherPlace.value = place;
                                },
                                child: _buildTable(
                                  context: context,
                                  theme: theme,
                                  name: place?.name ?? '',
                                  status: order == null ? 'free' : 'bron',
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
