import 'dart:developer';

import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/order_controller.dart';
import 'package:biznex/src/core/extensions/app_responsive.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:biznex/src/core/model/other_models/customer_model.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
import 'package:biznex/src/providers/employee_provider.dart';
import 'package:biznex/src/ui/screens/order_screens/order_item_card.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';
import 'package:biznex/src/ui/widgets/helpers/app_decorated_button.dart';
import '../settings_screen/order_settings_screen.dart';
import 'order_details_screen.dart';
import 'order_param_buttons.dart';

class OrderItemsPage extends HookConsumerWidget {
  final Place place;
  final AppColors theme;
  final AppModel state;
  final Order? order;

  const OrderItemsPage({
    this.order,
    super.key,
    required this.place,
    required this.theme,
    required this.state,
  });

  @override
  Widget build(BuildContext context, ref) {
    final orderItems = ref.watch(orderSetProvider);
    final orderNotifier = ref.read(orderSetProvider.notifier);
    final noteController = useTextEditingController(text: order?.note);
    final customerNotifier = useState<Customer?>(order?.customer);
    final scheduledTime = useState<DateTime?>(null);

    final placeOrderItems = useMemoized(
      () => orderItems.where((e) => e.placeId == place.id).toList(),
      [orderItems, place.id],
    );

    final totalPrice = placeOrderItems.fold<double>(
      0,
      (sum, item) => sum + (item.customPrice ?? item.amount * item.product.price),
    );

    useEffect(() {
      if (order != null) {
        Future.microtask(() {
          final existingIds = orderItems.map((e) => e.product.id).toSet();
          final newOnes = order!.products.where((e) {
            return !existingIds.contains(e.product.id);
          }).toList();
          if (newOnes.isNotEmpty) {
            orderNotifier.addMultiple(newOnes);
          }
        });
      }

      return null;
    }, [order]);

    void onSchedule() {
      showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2100)).then((date) {
        if (date != null) {
          showTimePicker(context: context, initialTime: TimeOfDay(hour: 13, minute: 0)).then((time) {
            if (time != null) {
              scheduledTime.value = date.copyWith(hour: time.hour, minute: time.minute);
            }
          });
        }
      });
    }

    return Expanded(
      flex: 4,
      child: placeOrderItems.isEmpty
          ? AppEmptyWidget()
          : Container(
              margin: Dis.only(right: context.w(32), top: context.h(24)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              padding: 16.tb,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    for (final item in placeOrderItems)
                      OrderItemCardNew(
                        item: item,
                        theme: theme,
                        order: order,
                      ),
                    // OrderDetailsScreen(
                    //   theme: theme,
                    //   noteController: noteController,
                    //   customerNotifier: customerNotifier,
                    // ),
                    // OrderParamButtons(
                    //   scheduleNotifier: scheduledTime,
                    //   theme: theme,
                    //   state: state,
                    //   onScheduleOrder: onSchedule,
                    //   onOpenSettings: () {
                    //     showDesktopModal(context: context, body: OrderSettingsScreen(state));
                    //   },
                    //   onClearAll: order != null ? null : () => orderNotifier.clear(),
                    // ),
                    Container(
                      margin: Dis.only(top: 16),
                      padding: Dis.only(tb: 24, lr: 16),
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: theme.scaffoldBgColor,
                              width: 2,
                            ),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          )),
                      child: Column(
                        spacing: 24,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${AppLocales.total.tr()}:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: mediumFamily,
                                ),
                              ),
                              Text(
                                totalPrice.priceUZS,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: boldFamily,
                                ),
                              ),
                            ],
                          ),
                          AppPrimaryButton(
                            theme: theme,
                            onPressed: () async {
                              OrderController orderController = OrderController(
                                model: state,
                                place: place,
                                employee: ref.watch(currentEmployeeProvider),
                              );

                              log((place.father == null).toString());

                              if (order == null) {
                                orderController.openOrder(
                                  context,
                                  ref,
                                  placeOrderItems,
                                  note: noteController.text.trim(),
                                  customer: customerNotifier.value,
                                  scheduledDate: scheduledTime.value,
                                );
                                return;
                              }

                              orderController.addItems(
                                context,
                                ref,
                                placeOrderItems,
                                order!,
                                note: noteController.text.trim(),
                                customer: customerNotifier.value,
                                scheduledDate: scheduledTime.value,
                              );

                              ///
                              ///
                            },
                            title: AppLocales.add.tr(),
                          ),
                          // ConfirmCancelButton(
                          //   onlyConfirm: true,
                          //   cancelColor: theme.scaffoldBgColor,
                          //   padding: Dis.only(tb: 20),
                          //   spacing: 16,
                          //   onConfirm: () async {
                          //     OrderController orderController = OrderController(
                          //       model: state,
                          //       place: place,
                          //       employee: ref.watch(currentEmployeeProvider),
                          //     );
                          //
                          //     log((place.father == null).toString());
                          //
                          //     if (order == null) {
                          //       orderController.openOrder(
                          //         context,
                          //         ref,
                          //         placeOrderItems,
                          //         note: noteController.text.trim(),
                          //         customer: customerNotifier.value,
                          //         scheduledDate: scheduledTime.value,
                          //       );
                          //       return;
                          //     }
                          //
                          //     orderController.addItems(
                          //       context,
                          //       ref,
                          //       placeOrderItems,
                          //       order!,
                          //       note: noteController.text.trim(),
                          //       customer: customerNotifier.value,
                          //       scheduledDate: scheduledTime.value,
                          //     );
                          //
                          //     ///
                          //     ///
                          //   },
                          //   onCancel: () async {
                          //     OrderController orderController = OrderController(
                          //       model: state,
                          //       place: place,
                          //       employee: ref.watch(currentEmployeeProvider),
                          //     );
                          //
                          //     await orderController.closeOrder(
                          //       context,
                          //       ref,
                          //       note: noteController.text.trim(),
                          //       customer: customerNotifier.value,
                          //       scheduledDate: scheduledTime.value,
                          //     );
                          //
                          //     noteController.clear();
                          //     customerNotifier.value = null;
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
