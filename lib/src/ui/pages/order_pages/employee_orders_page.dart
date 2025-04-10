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

  bool isToday(DateTime? time) {
    return time == null;
  }

  bool isTodayOrder(dateFilter, order) {
    final orderDate = DateTime.parse(order.createdDate);
    return (orderDate.year == dateFilter.value?.year) && (orderDate.month == dateFilter.value?.month) && (orderDate.day == dateFilter.value?.day);
  }

  @override
  Widget build(BuildContext context, ref) {
    final dateFilter = useState<DateTime?>(null);
    final employeeOrders = ref.watch(employeeOrdersProvider);
    final filterResult = useState(<Order>[]);
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
                    Spacer(),
                    if (!isToday(dateFilter.value))
                      Center(
                        child: RichText(
                          text: TextSpan(text: "${AppLocales.total.tr()}: ", style: TextStyle(fontSize: 18, color: theme.textColor), children: [
                            TextSpan(
                              text: orders.fold<double>(0, (value, element) {
                                if (isTodayOrder(dateFilter, element)) {
                                  return value += element.price;
                                }

                                return value += 0;
                              }).priceUZS,
                              style: TextStyle(fontSize: 18, color: theme.textColor, fontFamily: boldFamily),
                            ),
                          ]),
                        ),
                      ),
                    24.w,
                    SimpleButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(2025, 1),
                          lastDate: DateTime.now(),
                          initialDate: dateFilter.value,
                        ).then((date) {
                          if (date != null) {
                            dateFilter.value = date;
                            filterResult.value = [
                              ...orders.where(
                                (order) {
                                  final orderDate = DateTime.parse(order.createdDate);
                                  return (orderDate.year == dateFilter.value?.year) &&
                                      (orderDate.month == dateFilter.value?.month) &&
                                      (orderDate.day == dateFilter.value?.day);
                                },
                              ),
                            ];
                          }
                        });
                      },
                      child: Container(
                        padding: Dis.only(lr: 16, tb: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: theme.accentColor,
                        ),
                        child: Row(
                          spacing: 8,
                          children: [
                            Icon(Ionicons.calendar_outline, size: 20),
                            Text(
                              dateFilter.value == null
                                  ? AppLocales.all.tr()
                                  : DateFormat('dd-MMMM', context.locale.languageCode).format(dateFilter.value!),
                              style: TextStyle(fontFamily: mediumFamily),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: (isToday(dateFilter.value) && orders.isEmpty)
                      ? AppEmptyWidget()
                      : (!isToday(dateFilter.value) && filterResult.value.isEmpty)
                          ? AppEmptyWidget()
                          : ListView.builder(
                              itemCount: (isToday(dateFilter.value)) ? orders.length : filterResult.value.length,
                              itemBuilder: (context, index) {
                                final order = (isToday(dateFilter.value)) ? orders[index] : filterResult.value[index];
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
