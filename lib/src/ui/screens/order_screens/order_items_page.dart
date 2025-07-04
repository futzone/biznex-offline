import 'dart:developer';
import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/order_controller.dart';
import 'package:biznex/src/core/extensions/app_responsive.dart';
import 'package:biznex/src/core/extensions/device_type.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:biznex/src/core/model/other_models/customer_model.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
import 'package:biznex/src/providers/employee_provider.dart';
import 'package:biznex/src/ui/screens/order_screens/order_item_card.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/custom/app_error_screen.dart';
import 'package:biznex/src/ui/widgets/helpers/app_decorated_button.dart';
import 'package:biznex/src/ui/widgets/helpers/app_loading_screen.dart';

import '../../../providers/orders_provider.dart';

class OrderItemsPage extends HookConsumerWidget {
  final Place place;
  final AppColors theme;
  final AppModel state;

  const OrderItemsPage({
    super.key,
    required this.place,
    required this.theme,
    required this.state,
  });

  @override
  Widget build(BuildContext context, ref) {
    // final orderItems = ref.watch(orderSetProvider);
    // final orderNotifier = ref.read(orderSetProvider.notifier);

    final scheduledTime = useState<DateTime?>(null);
    final useCheck = useState(true);
    final paymentType = useState(AppLocales.useCash);

    // final placeOrderItems = useMemoized(
    //   () => orderItems.where((e) => e.placeId == place.id).toList(),
    //   [orderItems, place.id],
    // );
    //
    // final totalPrice = placeOrderItems.fold<double>(
    //   0,
    //   (sum, item) => sum + (item.customPrice ?? item.amount * item.product.price),
    // );

    useEffect(() {
      Future.microtask(() {
        ref.read(orderSetProvider.notifier).loadOrderForPlace(place.id);
      });
      return null;
    }, [place.id]);

    final orderItems = ref.watch(orderSetProvider);
    final orderNotifier = ref.read(orderSetProvider.notifier);

    final orderAsyncValue = ref.watch(ordersProvider(place.id));

    final placeOrderItems = useMemoized(
      () => orderItems.where((e) => e.placeId == place.id).toList(),
      [orderItems, place.id],
    );

    final totalPrice = placeOrderItems.fold<double>(
      0,
      (sum, item) => sum + (item.customPrice ?? item.amount * item.product.price),
    );

    return orderAsyncValue.when(
      loading: () => AppLoadingScreen(),
      error: RefErrorScreen,
      data: (order) {
        final noteController = useTextEditingController(text: order?.note);
        final customerNotifier = useState<Customer?>(order?.customer);
        return Expanded(
          flex: getDeviceType(context) == DeviceType.tablet ? 6 : 4,
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
                          margin: Dis.only(top: context.h(16)),
                          padding: Dis.only(tb: context.h(24), lr: context.w(16)),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 8,
                            children: [
                              SwitchListTile(
                                activeColor: theme.mainColor,
                                contentPadding: Dis.only(),
                                value: useCheck.value,
                                onChanged: (v) => useCheck.value = v,
                                title: Text(
                                  "${AppLocales.printing.tr()}:",
                                  style: TextStyle(
                                    fontSize: context.s(16),
                                    fontFamily: mediumFamily,
                                  ),
                                ),
                              ),
                              Container(
                                height: 1,
                                margin: 8.tb,
                                color: theme.accentColor,
                              ),
                              Text(
                                "${AppLocales.paymentType.tr()}:",
                                style: TextStyle(
                                  fontSize: context.s(16),
                                  fontFamily: mediumFamily,
                                ),
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                runAlignment: WrapAlignment.start,
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  ...[
                                    AppLocales.useCash,
                                    AppLocales.useDebt,
                                    AppLocales.useCard,
                                    AppLocales.payme,
                                    AppLocales.click,
                                  ].map((type) {
                                    return ChoiceChip(
                                      backgroundColor: theme.scaffoldBgColor,
                                      selectedColor: theme.mainColor,
                                      padding: Dis.only(),
                                      checkmarkColor: paymentType.value == type ? Colors.white : Colors.black,
                                      label: Text(
                                        type.tr(),
                                        style: TextStyle(color: paymentType.value == type ? Colors.white : Colors.black, fontSize: context.s(14)),
                                      ),
                                      selected: paymentType.value == type,
                                      onSelected: (_) {
                                        paymentType.value = type;
                                      },
                                    );
                                  }),
                                ],
                              ),

                              Container(
                                height: 1,
                                margin: 16.tb,
                                color: theme.accentColor,
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${AppLocales.total.tr()}:",
                                    style: TextStyle(
                                      fontSize: context.s(16),
                                      fontFamily: mediumFamily,
                                    ),
                                  ),
                                  Text(
                                    totalPrice.priceUZS,
                                    style: TextStyle(
                                      fontSize: context.s(20),
                                      fontFamily: boldFamily,
                                    ),
                                  ),
                                ],
                              ),
                              8.h,
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
                              8.h,
                              AppPrimaryButton(
                                theme: theme,
                                onPressed: () async {
                                  OrderController orderController = OrderController(
                                    model: state,
                                    place: place,
                                    employee: ref.watch(currentEmployeeProvider),
                                  );

                                  await orderController.closeOrder(
                                    context,
                                    ref,
                                    note: noteController.text.trim(),
                                    customer: customerNotifier.value,
                                    scheduledDate: scheduledTime.value,
                                    paymentType: paymentType.value,
                                    useCheck: useCheck.value,
                                  );

                                  noteController.clear();
                                  customerNotifier.value = null;
                                },
                                textColor: theme.mainColor,
                                border: Border.all(color: theme.mainColor),
                                color: theme.white,
                                title: AppLocales.close.tr(),
                                // icon: Icons.close,
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
      },
    );
  }
}
