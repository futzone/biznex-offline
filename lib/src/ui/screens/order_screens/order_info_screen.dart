import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:biznex/src/ui/screens/order_screens/order_item_card.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/custom/app_text_widgets.dart';
import 'package:biznex/src/ui/widgets/helpers/app_decorated_button.dart';

class OrderInfoScreen extends HookConsumerWidget {
  final Order order;

  const OrderInfoScreen(this.order, {super.key});

  @override
  Widget build(BuildContext context, ref) {
    return AppStateWrapper(builder: (theme, state) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              2.h,
              AppText.$18Bold(AppLocales.orderItems.tr()),
              for (final item in order.products) OrderItemCardNew(item: item, theme: theme, infoView: true),
              0.h,
              Row(
                children: [
                  Text("${AppLocales.status.tr()}: ", style: TextStyle(fontSize: 16)),
                  AppText.$18Bold(order.status?.tr() ?? ''),
                  Spacer(),
                  Text("${AppLocales.total.tr()}: ", style: TextStyle(fontSize: 16)),
                  AppText.$18Bold(order.price.priceUZS),
                ],
              ),
              0.h,
              Row(
                children: [
                  Text("${AppLocales.place.tr()}: ", style: TextStyle(fontSize: 16)),
                  AppText.$18Bold(order.place.father == null ? order.place.name : "${order.place.father?.name}, ${order.place.name}"),
                  Spacer(),
                  Text("${order.employee.roleName}: ", style: TextStyle(fontSize: 16)),
                  AppText.$18Bold(order.employee.fullname),
                ],
              ),
              0.h,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (order.customer != null) Text("${AppLocales.customer.tr()}: ", style: TextStyle(fontSize: 16)),
                  if (order.customer != null) AppText.$18Bold(order.customer!.name),
                  Spacer(),
                  AppPrimaryButton(
                    color: theme.accentColor,
                    padding: Dis.only(lr: 20, tb: 8),
                    theme: theme,
                    child: Row(
                      spacing: 8,
                      children: [
                        Icon(Ionicons.print_outline),
                        Text(AppLocales.print.tr()),
                      ],
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              0.h,
              if (order.note != null)
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${AppLocales.orderNote.tr()}: ", style: TextStyle(fontSize: 16)),
                    Text(order.note ?? '', style: TextStyle(fontSize: 16, fontFamily: boldFamily)),
                  ],
                ),
              16.h,
            ],
          ),
        ),
      );
    });
  }
}
