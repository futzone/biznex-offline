import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/core/extensions/app_responsive.dart';
import 'package:biznex/src/core/extensions/for_string.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
import 'package:biznex/src/ui/pages/order_pages/employee_orders_page.dart';
import 'package:biznex/src/ui/pages/order_pages/table_choose_screen.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';
import 'package:biznex/src/ui/widgets/helpers/app_back_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/model/order_models/order_model.dart';
import '../../../providers/employee_provider.dart';
import '../../../providers/orders_provider.dart';
import '../../screens/order_screens/order_half_page.dart';
import '../../screens/order_screens/order_items_page.dart';

class MenuPage extends HookConsumerWidget {
  final Place place;
  final Place? fatherPlace;

  const MenuPage({super.key, required this.place, this.fatherPlace});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employee = ref.watch(currentEmployeeProvider);
    return AppStateWrapper(builder: (theme, state) {
      return Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.white,
              padding: Dis.only(lr: context.w(32), tb: context.h(24)),
              child: Row(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppBackButton(
                    onPressed: ()=>AppRouter.open(context, TableChooseScreen()),
                  ),
                  0.w,
                  SvgPicture.asset(
                    'assets/images/Vector.svg',
                    height: 36,
                  ),
                  Spacer(),
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
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: focused ? theme.mainColor.withValues(alpha: 0.1) : null,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: theme.secondaryTextColor),
                        ),
                        child: Icon(Ionicons.list_outline),
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
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  OrderHalfPage(place),
                  Container(
                    height: double.infinity,
                    width: 2,
                    color: Colors.white,
                    margin: Dis.only(lr: context.w(24)),
                  ),
                  state.whenProviderData(
                    provider: ordersProvider(place.id),
                    builder: (order) {
                      order as Order?;
                      Place? kPlace;

                      kPlace = place;
                      if (fatherPlace != null) {
                        kPlace.father = fatherPlace;
                      }

                      return OrderItemsPage(state: state, theme: theme, place: kPlace, order: order);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
