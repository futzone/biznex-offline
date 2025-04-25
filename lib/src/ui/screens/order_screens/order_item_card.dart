import 'dart:io';
import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/extensions/device_type.dart';
import 'package:biznex/src/ui/screens/products_screens/product_screen.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';

import '../../../core/model/order_models/order_model.dart';

class OrderItemCardNew extends HookConsumerWidget {
  final OrderItem item;
  final AppColors theme;
  final bool infoView;
  final Order? order;

  const OrderItemCardNew({
    super.key,
    this.order,
    this.infoView = false,
    required this.item,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, ref) {
    final product = item.product;
    final controller = useTextEditingController(text: item.amount.price);
    final orderNotifier = ref.read(orderSetProvider.notifier);
    final itemIsSaved = useState(false);

    bool isTablet = getDeviceType(context) == DeviceType.tablet;

    useEffect(() {
      final newText = item.amount.toString();
      if (controller.text != newText) {
        final cursorPos = controller.selection.baseOffset;
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(
            offset: cursorPos > newText.length ? newText.length : cursorPos,
          ),
        );
      }

      itemIsSaved.value = (item.amount !=
          order?.products.firstWhere(
                (e) => e.product.id == item.product.id,
            orElse: () => item.copyWith(amount: -1),
          ).amount);

      return null;
    }, [item.amount, order]);


    return AppStateWrapper(builder: (theme, model) {
      return SimpleButton(
        onPressed: () {
          showDesktopModal(
            context: context,
            width: MediaQuery.of(context).size.width * 0.4,
            body: ProductScreen(product),
          );
        },
        child: AnimatedContainer(
          duration: theme.animationDuration,
          margin: Dis.only(bottom: 8),
          padding: Dis.only(lr: 16, tb: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: infoView
                ? theme.accentColor
                : itemIsSaved.value
                    ? theme.mainColor.withOpacity(0.2)
                    : infoView
                        ? theme.accentColor
                        : theme.scaffoldBgColor,
          ),
          child: isTablet
              ? Column(
                  children: [
                    Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: theme.scaffoldBgColor,
                                image: (product.images != null && product.images!.isNotEmpty)
                                    ? DecorationImage(image: FileImage(File(product.images!.first)), fit: BoxFit.cover)
                                    : null,
                                border: Border.all(color: theme.accentColor)
                              ),
                              child: !(product.images == null || product.images!.isEmpty)
                                  ? null
                                  : Center(
                                      child: Text(
                                        product.name.trim()[0],
                                        style: TextStyle(
                                          color: theme.textColor,
                                          fontSize: 24,
                                          fontFamily: boldFamily,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            spacing: 4,
                            children: [
                              Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                              Row(
                                spacing: 24,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (!infoView) Text(product.size ?? ''),
                                  if (!infoView) Text(product.price.priceUZS, style: TextStyle(fontFamily: boldFamily, fontSize: 16)),
                                  if (infoView)
                                    Text("${item.amount.price} * ${product.price.priceUZS}", style: TextStyle(fontFamily: boldFamily, fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: 16.tb,
                      height: 1,
                      width: double.infinity,
                      color: theme.accentColor,
                    ),
                    Row(
                      spacing: 16,
                      children: [
                        if (!infoView)
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                WebButton(
                                  onPressed: () => orderNotifier.addItem(item),
                                  builder: (focused) {
                                    return Icon(
                                      Ionicons.add_circle_outline,
                                      size: 40,
                                      color: focused ? theme.mainColor : theme.secondaryTextColor,
                                    );
                                  },
                                ),
                                8.w,
                                TextField(
                                  onChanged: (char) async {
                                    final value = num.tryParse(char.replaceAll(',', '.'));
                                    if (value == null) {
                                      return orderNotifier.deleteItem(item, model, context);
                                    }
                                    OrderItem orderItem = item;
                                    orderItem.amount = value.toDouble();
                                    orderNotifier.updateItem(item);
                                  },

                                  controller: controller,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: theme.textColor),
                                  cursorHeight: 16,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: Dis.only(tb: 8),
                                    constraints: const BoxConstraints(maxWidth: 64),
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(24),
                                      ),
                                      borderSide: BorderSide(color: theme.mainColor),
                                    ),
                                  ),
                                ),
                                8.w,
                                WebButton(
                                  onPressed: () {
                                    orderNotifier.removeItem(item, model, context);
                                  },
                                  builder: (focused) {
                                    return Icon(
                                      Ionicons.remove_circle_outline,
                                      size: 40,
                                      color: focused ? theme.mainColor : theme.secondaryTextColor,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        if (!infoView)
                          IconButton.outlined(
                            onPressed: () {
                              orderNotifier.deleteItem(item, model, context);
                            },
                            color: Colors.red,
                            style: IconButton.styleFrom(side: BorderSide(color: Colors.red)),
                            icon: Icon(Icons.delete_outline),
                          ),
                        if (infoView)
                          Expanded(
                            child: Center(
                              child: Text(
                                (item.amount * item.product.price).priceUZS,
                                style: TextStyle(fontSize: 18, fontFamily: boldFamily),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                )
              : Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: theme.scaffoldBgColor,
                            image: (product.images != null && product.images!.isNotEmpty)
                                ? DecorationImage(image: FileImage(File(product.images!.first)), fit: BoxFit.cover)
                                : null,
                          ),
                          child: !(product.images == null || product.images!.isEmpty)
                              ? null
                              : Center(
                                  child: Text(
                                    product.name.trim()[0],
                                    style: TextStyle(
                                      color: theme.textColor,
                                      fontSize: 24,
                                      fontFamily: boldFamily,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        spacing: 4,
                        children: [
                          Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                          Row(
                            spacing: 24,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!infoView) Text(product.size ?? ''),
                              if (!infoView) Text(product.price.priceUZS, style: TextStyle(fontFamily: boldFamily, fontSize: 16)),
                              if (infoView)
                                Text("${item.amount.price} * ${product.price.priceUZS}", style: TextStyle(fontFamily: boldFamily, fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!infoView)
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            WebButton(
                              onPressed: () => orderNotifier.addItem(item),
                              builder: (focused) {
                                return Icon(
                                  Ionicons.add_circle_outline,
                                  size: 40,
                                  color: focused ? theme.mainColor : theme.secondaryTextColor,
                                );
                              },
                            ),
                            8.w,
                            TextField(
                              onChanged: (char) async {
                                final value = num.tryParse(char.replaceAll(',', '.'));
                                if (value == null) {
                                  return orderNotifier.deleteItem(item, model, context);
                                }
                                OrderItem orderItem = item;
                                orderItem.amount = value.toDouble();
                                orderNotifier.updateItem(item);
                              },

                              controller: controller,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: theme.textColor),
                              cursorHeight: 16,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: Dis.only(tb: 8),
                                constraints: const BoxConstraints(maxWidth: 64),
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(24),
                                  ),
                                  borderSide: BorderSide(color: theme.mainColor),
                                ),
                              ),
                            ),
                            8.w,
                            WebButton(
                              onPressed: () {
                                orderNotifier.removeItem(item, model, context);
                              },
                              builder: (focused) {
                                return Icon(
                                  Ionicons.remove_circle_outline,
                                  size: 40,
                                  color: focused ? theme.mainColor : theme.secondaryTextColor,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    if (!infoView)
                      IconButton.outlined(
                        onPressed: () {
                          orderNotifier.deleteItem(item, model, context);
                        },
                        color: Colors.red,
                        style: IconButton.styleFrom(side: BorderSide(color: Colors.red)),
                        icon: Icon(Icons.delete_outline),
                      ),
                    if (infoView)
                      Expanded(
                        child: Center(
                          child: Text(
                            (item.amount * item.product.price).priceUZS,
                            style: TextStyle(fontSize: 18, fontFamily: boldFamily),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      );
    });
  }
}
