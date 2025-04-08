import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/order_controller.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:biznex/src/core/model/other_models/customer_model.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
import 'package:biznex/src/providers/employee_provider.dart';
import 'package:biznex/src/ui/screens/order_screens/order_item_card.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/helpers/app_decorated_button.dart';
import 'package:biznex/src/ui/widgets/helpers/app_text_field.dart';

import 'order_details_screen.dart';

class OrderItemsPage extends HookConsumerWidget {
  final Place place;
  final AppColors theme;
  final AppModel state;
  final Order? order;

  const OrderItemsPage({this.order, super.key, required this.place, required this.theme, required this.state});

  @override
  Widget build(BuildContext context, ref) {
    final orderItems = ref.watch(orderSetProvider);
    final orderNotifier = ref.read(orderSetProvider.notifier);
    final noteController = useTextEditingController();
    final customerNotifier = useState<Customer?>(null);

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
          final newOnes = order!.products.where((e) => !existingIds.contains(e.product.id)).toList();
          if (newOnes.isNotEmpty) {
            orderNotifier.addMultiple(newOnes);
          }
        });
      }

      return null;
    }, [order]);

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
                          itemCount: placeOrderItems.length + 1,
                          itemBuilder: (context, index) {
                            if (index == placeOrderItems.length) {
                              return OrderDetailsScreen(
                                theme: theme,
                                noteController: noteController,
                                customerNotifier: customerNotifier,
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
                              orderController.openOrder(placeOrderItems);
                              return;
                            }

                            orderController.addItems(placeOrderItems);
                          },
                          onCancel: () async {
                            OrderController orderController = OrderController(
                              model: state,
                              context: context,
                              place: place,
                              employee: ref.watch(currentEmployeeProvider),
                            );

                            orderController.closeOrder();
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
  }
}
