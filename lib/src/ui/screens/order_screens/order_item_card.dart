import 'dart:io';
import 'package:biznex/biznex.dart';
import 'package:biznex/src/ui/screens/products_screens/product_screen.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';

class OrderItemCardNew extends HookConsumerWidget {
  final OrderItem item;
  final AppColors theme;
  final bool infoView;

  const OrderItemCardNew({super.key, this.infoView = false, required this.item, required this.theme});

  @override
  Widget build(BuildContext context, ref) {
    final product = item.product;
    final controller = useTextEditingController(text: item.amount.price);
    final orderNotifier = ref.read(orderSetProvider.notifier);

    useEffect(() {
      controller.text = item.amount.price;
      return null;
    }, [item.amount]);

    return WebButton(
      onPressed: () {
        showDesktopModal(
          context: context,
          width: MediaQuery.of(context).size.width * 0.4,
          body: ProductScreen(product),
        );
      },
      builder: (focused) => AnimatedContainer(
        duration: theme.animationDuration,
        margin: Dis.only(bottom: 8),
        padding: Dis.only(lr: 16, tb: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: focused ? theme.mainColor : theme.accentColor),
          color: focused
              ? theme.mainColor.withOpacity(0.1)
              : infoView
                  ? theme.accentColor
                  : theme.scaffoldBgColor,
        ),
        child: Row(
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
                      if (infoView) Text("${item.amount.price} * ${product.price.priceUZS}", style: TextStyle(fontFamily: boldFamily, fontSize: 16)),
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
                        final value = num.tryParse(char);
                        if (value == null) {
                          return orderNotifier.deleteItem(item);
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
                        orderNotifier.removeItem(item);
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
                  orderNotifier.deleteItem(item);
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
  }
}
