import 'package:biznex/biznex.dart';
import 'package:biznex/src/ui/screens/order_screens/order_item_card.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/helpers/app_decorated_button.dart';

class OrderItemsPage extends HookConsumerWidget {
  final AppColors theme;
  final AppModel state;

  const OrderItemsPage({super.key, required this.theme, required this.state});

  @override
  Widget build(BuildContext context, ref) {
    final orderItems = ref.watch(orderSetProvider);
    double totalPrice = orderItems.fold(0, (oldValue, element) {
      return oldValue += (element.customPrice ?? (element.amount * element.product.price));
    });
    return Expanded(
      child: orderItems.isEmpty
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
                          itemCount: orderItems.length,
                          itemBuilder: (context, index) {
                            final item = orderItems[index];
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
