import 'dart:developer';

import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/order_controller.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
import 'package:biznex/src/providers/employee_provider.dart';
import 'package:biznex/src/providers/orders_provider.dart';
import 'package:biznex/src/ui/screens/order_screens/order_item_card.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/helpers/app_decorated_button.dart';

class OrderItemsPage extends HookConsumerWidget {
  final Place place;
  final AppColors theme;
  final AppModel state;

  const OrderItemsPage({super.key, required this.place, required this.theme, required this.state});

  @override
  Widget build(BuildContext context, ref) {
    final orderItems = ref.watch(orderSetProvider);
    final currentEmployee = ref.watch(currentEmployeeProvider);
    List<OrderItem> placeOrderItemsState = orderItems.where((el) => el.placeId == place.id).toList();

    final controller = useState(OrderController(model: state, context: context, place: place, employee: currentEmployee));

    return state.whenProviderData(
      provider: ordersProvider(place.id),
      builder: (order) {
        order as Order?;

        if (order == null && placeOrderItemsState.isEmpty) return Expanded(child: AppEmptyWidget());

        List<OrderItem> placeOrderItems = [...placeOrderItemsState, ...(order == null ? [] : order.products)];
        double totalPrice = placeOrderItems.fold(0, (oldValue, element) {
          return oldValue += (element.customPrice ?? (element.amount * element.product.price));
        });

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
                              itemCount: placeOrderItems.length,
                              itemBuilder: (context, index) {
                                final item = placeOrderItems[index];

                                return OrderItemCardNew(item: item, theme: theme, controllerNotifier: controller);
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
                                  orderController.openOrder(placeOrderItemsState);
                                  return;
                                }

                                orderController.addItems(placeOrderItemsState);
                              },
                            ),
                          ),
                          16.w,
                        ],
                      )
                    ],
                  ),
                ),
        );
      },
    );
  }
}
