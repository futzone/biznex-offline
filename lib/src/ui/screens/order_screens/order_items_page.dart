import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/order_controller.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:biznex/src/core/model/other_models/customer_model.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
import 'package:biznex/src/core/services/printer_services.dart';
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
      child: placeOrderItems.isEmpty
          ? AppEmptyWidget()
          : Container(
              margin: 16.all,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: theme.accentColor,
              ),
              padding: 16.tb,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: 16.lr,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ListView.builder(
                          padding: 8.tb,
                          itemCount: placeOrderItems.length + 2,
                          itemBuilder: (context, index) {
                            if (index == placeOrderItems.length) {
                              return OrderDetailsScreen(
                                theme: theme,
                                noteController: noteController,
                                customerNotifier: customerNotifier,
                              );
                            }

                            if (index == placeOrderItems.length + 1) {
                              return OrderParamButtons(
                                scheduleNotifier: scheduledTime,
                                theme: theme,
                                state: state,
                                onScheduleOrder: onSchedule,
                                onOpenSettings: () {
                                  showDesktopModal(context: context, body: OrderSettingsScreen(state));
                                },
                                onClearAll: order != null ? null : () => orderNotifier.clear(),
                              );
                            }

                            final item = placeOrderItems[index];
                            return OrderItemCardNew(item: item, theme: theme);
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: 16.tb,
                    color: theme.scaffoldBgColor,
                    width: double.infinity,
                    height: 4,
                  ),
                  Row(
                    children: [
                      16.w,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${AppLocales.total.tr()}:"),
                          Text(
                            totalPrice.priceUZS,
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: boldFamily,
                            ),
                          ),
                        ],
                      ),
                      16.w,
                      Expanded(
                        child: ConfirmCancelButton(
                          cancelColor: theme.scaffoldBgColor,
                          padding: Dis.only(tb: 20),
                          spacing: 16,
                          onConfirm: () async {
                            OrderController orderController = OrderController(
                              model: state,
                              context: context,
                              place: place,
                              employee: ref.watch(currentEmployeeProvider),
                            );

                            if (order == null) {
                              orderController.openOrder(
                                placeOrderItems,
                                note: noteController.text.trim(),
                                customer: customerNotifier.value,
                                scheduledDate: scheduledTime.value,
                              );
                              return;
                            }

                            orderController.addItems(
                              placeOrderItems,
                              note: noteController.text.trim(),
                              customer: customerNotifier.value,
                              scheduledDate: scheduledTime.value,
                            );
                          },
                          onCancel: () async {
                            OrderController orderController = OrderController(
                              model: state,
                              context: context,
                              place: place,
                              employee: ref.watch(currentEmployeeProvider),
                            );

                            await orderController.closeOrder(
                              note: noteController.text.trim(),
                              customer: customerNotifier.value,
                              scheduledDate: scheduledTime.value,
                            );


                            noteController.clear();
                            customerNotifier.value = null;
                          },
                        ),
                      ),
                      16.w,
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
