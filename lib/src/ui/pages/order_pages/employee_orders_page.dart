import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:biznex/src/providers/employee_orders_provider.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/custom/app_error_screen.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/custom/app_text_widgets.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';
import 'package:biznex/src/ui/widgets/helpers/app_loading_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../screens/order_screens/order_info_screen.dart';

class EmployeeOrdersPage extends HookConsumerWidget {
  const EmployeeOrdersPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final employeeOrders = ref.watch(employeeOrdersProvider);
    return AppStateWrapper(
      builder: (theme, state) {
        return employeeOrders.when(
          loading: () => AppLoadingScreen(),
          error: (error, stackTrace) => AppErrorScreen(),
          data: (orders) {
            return Column(
              spacing: 12,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Center(
                      child: IconButton(
                        onPressed: () {
                          AppRouter.close(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_new),
                      ),
                    ),
                    Center(
                      child: AppText.$18Bold(
                        AppLocales.myOrders.tr(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: (orders.isEmpty)
                      ? AppEmptyWidget()
                      : ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return WebButton(
                              onPressed: () {
                                showDesktopModal(
                                  context: context,
                                  body: OrderInfoScreen(order),
                                  width: MediaQuery.of(context).size.width * 0.4,
                                );
                              },
                              builder: (focused) {
                                return AnimatedContainer(
                                  margin: 16.bottom,
                                  padding: 16.all,
                                  duration: theme.animationDuration,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: focused ? theme.mainColor.withOpacity(0.2) : theme.accentColor,
                                    border: Border.all(color: focused ? theme.mainColor : theme.accentColor),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          spacing: 8,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              spacing: 8,
                                              children: [
                                                Icon(Ionicons.time_outline),
                                                Text(
                                                  "${AppLocales.createdDate.tr()}: ",
                                                  style: TextStyle(),
                                                ),
                                                Text(
                                                  DateFormat('yyyy.MM.dd, HH:mm').format(DateTime.parse(order.createdDate)),
                                                  style: TextStyle(fontFamily: boldFamily),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              spacing: 8,
                                              children: [
                                                Icon(Ionicons.time_outline),
                                                Text(
                                                  "${order.status == Order.completed ? AppLocales.closedDate : AppLocales.updatedDate.tr()}: ",
                                                  style: TextStyle(),
                                                ),
                                                Text(
                                                  DateFormat('yyyy.MM.dd, HH:mm').format(DateTime.parse(order.createdDate)),
                                                  style: TextStyle(fontFamily: boldFamily),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          spacing: 8,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              spacing: 8,
                                              children: [
                                                SvgPicture.asset('assets/icons/dining-table.svg', height: 24, width: 24),
                                                Text(
                                                  "${AppLocales.place.tr()}: ",
                                                  style: TextStyle(),
                                                ),
                                                Text(
                                                  "${order.place.father != null ? '${order.place.father!.name}, ' : ''}${order.place.name}",
                                                  style: TextStyle(fontFamily: boldFamily),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              spacing: 8,
                                              children: [
                                                Icon(Ionicons.wallet_outline),
                                                Text(
                                                  "${AppLocales.total.tr()}: ",
                                                  style: TextStyle(),
                                                ),
                                                Text(
                                                  order.price.priceUZS,
                                                  style: TextStyle(fontFamily: boldFamily),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      if (order.status == Order.completed) Center(child: Icon(Icons.done, size: 32, color: theme.mainColor)),
                                      if (order.status == Order.cancelled) Center(child: Icon(Icons.close, size: 32, color: Colors.red)),
                                      if (order.status == Order.opened) Center(child: Icon(Icons.close, size: 32, color: Colors.amber)),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
