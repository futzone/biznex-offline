import 'package:biznex/src/core/extensions/app_responsive.dart';
import 'package:biznex/src/core/extensions/for_string.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
import 'package:biznex/src/providers/employee_provider.dart';
import 'package:biznex/src/providers/orders_provider.dart';
import 'package:biznex/src/providers/places_provider.dart';
import 'package:biznex/src/ui/widgets/custom/app_custom_popup_menu.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../biznex.dart';
import '../../../core/model/order_models/order_model.dart';

class TableChooseScreen extends HookConsumerWidget {
  const TableChooseScreen({super.key});

  Widget _buildHorCursi() {
    return Container(
      height: 12,
      width: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors(isDark: false).secondaryTextColor.withValues(alpha: 0.4), width: 2),
      ),
    );
  }

  Widget _buildVerCursi() {
    return Container(
      width: 12,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors(isDark: false).secondaryTextColor.withValues(alpha: 0.4), width: 2),
      ),
    );
  }

  Widget _buildTable({required AppColors theme, required String name, required String status}) {
    final cColor = status == 'free' ? theme.mainColor.withValues(alpha: 0.36) : theme.accentColor.withValues(alpha: 0.36);
    final textColor = status == 'free' ? theme.mainColor : theme.secondaryTextColor;

    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHorCursi(),
        Expanded(
          child: Row(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildVerCursi(),
              Expanded(
                child: Container(
                  padding: 20.all,
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
                          fontSize: 20,
                          color: textColor,
                          fontFamily: mediumFamily,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _buildVerCursi(),
            ],
          ),
        ),
        _buildHorCursi(),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employee = ref.watch(currentEmployeeProvider);
    final selectedPlace = useState<Place?>(null);
    final filteredPlaces = useState<List<Place>>([]);
    final selectedFilter = useState<String?>(null);
    return AppStateWrapper(
      builder: (theme, state) {
        return Scaffold(
          body: state.whenProviderData(
            provider: placesProvider,
            builder: (places) {
              places as List<Place>;
              if (places.isEmpty) return AppEmptyWidget();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    padding: Dis.only(lr: context.w(32), tb: context.h(24)),
                    child: Row(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/images/Vector.svg',
                          height: 36,
                        ),
                        Spacer(),
                        WebButton(
                          onPressed: () {},
                          builder: (focused) {
                            return Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: focused ? theme.mainColor.withValues(alpha: 0.1) : null,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: theme.secondaryTextColor),
                              ),
                              child: Icon(Iconsax.notification_copy),
                            );
                          },
                        ),
                        WebButton(
                          onPressed: () {},
                          builder: (focused) {
                            return Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: focused ? theme.mainColor.withValues(alpha: 0.1) : null,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: theme.mainColor),
                              ),
                              child: Center(
                                child: Text(
                                  employee.fullname.initials,
                                  style: TextStyle(
                                    fontSize: 20,
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
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocales.choosePlace.tr(),
                          style: TextStyle(
                            fontFamily: mediumFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                        Row(
                          spacing: 16,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                color: Colors.white,
                              ),
                              padding: 12.all,
                              child: Row(
                                spacing: 8,
                                children: [
                                  Icon(Icons.circle, color: theme.mainColor, size: 16),
                                  Text(
                                    AppLocales.freeTables.tr(),
                                    style: TextStyle(
                                      fontSize: 16,
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
                              padding: 12.all,
                              child: Row(
                                spacing: 8,
                                children: [
                                  Icon(Icons.circle, color: theme.secondaryTextColor, size: 16),
                                  Text(
                                    AppLocales.bronTables.tr(),
                                    style: TextStyle(
                                      fontSize: 16,
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
                          spacing: 16,
                          children: [
                            CustomPopupMenu(
                              theme: theme,
                              children: [
                                for (final item in places)
                                  CustomPopupItem(title: item.name, onPressed: () => selectedPlace.value = item, icon: Icons.present_to_all),
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
                                  spacing: 8,
                                  children: [
                                    Text(
                                      selectedPlace.value == null ? AppLocales.choosePlace.tr() : selectedPlace.value!.name,
                                      style: TextStyle(fontSize: 16, fontFamily: mediumFamily),
                                    ),
                                    Icon(Iconsax.arrow_down_1_copy, size: 20),
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
                        padding: Dis.only(tb: 40),
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

                          return SimpleButton(
                            onPressed: () {
                              selectedPlace.value = place;
                            },
                            child: state.whenProviderData(
                              provider: ordersProvider(place?.id ?? ''),
                              builder: (order) {
                                order as Order?;
                                return _buildTable(
                                  theme: theme,
                                  name: place?.name ?? '',
                                  status: order == null ? 'free' : 'bron',
                                );
                              },
                            ),
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
