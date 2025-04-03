import 'dart:io';
import 'package:biznex/biznex.dart';
import 'package:biznex/src/ui/screens/products_screens/product_screen.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';

class OrderItemCardNew extends HookConsumerWidget {
  final OrderItem item;
  final AppColors theme;

  const OrderItemCardNew({super.key, required this.item, required this.theme});

  @override
  Widget build(BuildContext context, ref) {
    final product = item.product;
    final orders = ref.watch(orderSetProvider);
    final first = orders.firstWhere((v) => v.product.id == item.product.id);
    final priceController = useTextEditingController(text: "${(first.amount * first.product.price).toStringAsFixed(1)} UZS");
    final controller = useTextEditingController(text: first.amount.toString());

    useEffect(() {
      final newValue = orders.firstWhere((v) => v.product.id == item.product.id).amount.toString();

      if (controller.text != newValue) {
        final cursorPosition = controller.selection.baseOffset;
        controller.text = newValue;

        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: cursorPosition.clamp(0, newValue.length)),
        );
      }

      final newValuePrice = orders.firstWhere((v) => v.product.id == item.product.id);

      if (priceController.text != (newValuePrice.amount * newValuePrice.product.price).toStringAsFixed(1)) {
        final cursorPosition = priceController.selection.baseOffset;
        priceController.text = "${(newValuePrice.amount * newValuePrice.product.price).toStringAsFixed(1)} UZS";

        priceController.selection = TextSelection.fromPosition(
          TextPosition(offset: cursorPosition.clamp(0, priceController.text.length)),
        );
      }
      return null;
    }, [orders]);

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
        margin: 8.tb,
        padding: Dis.only(lr: 16, tb: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: focused ? theme.mainColor : theme.accentColor),
          color: focused ? theme.mainColor.withOpacity(0.1) : theme.accentColor,
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
                children: [Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis), Text(product.price.priceUZS)],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                spacing: 8,
                children: [
                  Row(
                    children: [
                      WebButton(
                        onPressed: () {
                          OrderItem orderItem = item;
                          orderItem.amount++;
                          updateOrderItem(ref, orderItem);
                        },
                        builder: (focused) {
                          return Icon(
                            Ionicons.add_circle_outline,
                            size: 24,
                            color: focused ? theme.mainColor : theme.secondaryTextColor,
                          );
                        },
                      ),
                      8.w,
                      Expanded(
                        child: TextField(
                          onChanged: (char) {
                            final value = num.tryParse(char);
                            if (value == null) return;
                            OrderItem orderItem = item;
                            orderItem.amount = value.toDouble();
                            updateOrderItem(ref, orderItem);
                          },
                          controller: controller,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: theme.textColor),
                          cursorHeight: 16,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: Dis.only(),
                            constraints: const BoxConstraints(maxWidth: 64),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4),
                              ),
                              borderSide: BorderSide(color: theme.mainColor),
                            ),
                          ),
                        ),
                      ),
                      8.w,
                      WebButton(
                        onPressed: () {
                          OrderItem orderItem = item;
                          orderItem.amount--;
                          updateOrderItem(ref, orderItem);
                        },
                        builder: (focused) {
                          return Icon(
                            Ionicons.remove_circle_outline,
                            size: 24,
                            color: focused ? theme.mainColor : theme.secondaryTextColor,
                          );
                        },
                      ),
                    ],
                  ),
                  TextField(
                    controller: priceController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: theme.textColor),
                    cursorHeight: 16,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: Dis.only(tb: 8),
                      // constraints: const BoxConstraints(maxWidth: 64),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        borderSide: BorderSide(color: theme.mainColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton.outlined(
              onPressed: () {
                ref.read(orderSetProvider.notifier).update((state) {
                  final newState = [...state];
                  newState.remove(item);
                  return newState;
                });
              },
              icon: Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
