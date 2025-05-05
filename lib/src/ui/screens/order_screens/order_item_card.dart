import 'dart:io';
import 'package:biznex/biznex.dart';
import 'package:biznex/src/ui/screens/products_screens/product_screen.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';

import '../../../core/model/order_models/order_model.dart';
import '../../widgets/custom/app_file_image.dart';

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

  num? _tryParseNum(String text) {
    return num.tryParse(text.replaceAll(',', '.').replaceAll(' ', ''));
  }

  String _formatDecimal(num value) {
    if (value.isNaN || value.isInfinite) {
      return value.toString();
    }

    num roundedValue = double.parse(value.toStringAsFixed(3));
    String formatted = roundedValue.toString();

    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0*$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    }
    return formatted;
  }

  void _updateControllerText(TextEditingController controller, num newValue) {
    final newText = _formatDecimal(newValue);
    if (controller.text != newText) {
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = item.product;
    final amountController = useTextEditingController(text: _formatDecimal(item.amount));
    final totalPriceController = useTextEditingController(text: _formatDecimal(item.amount * product.price));

    final orderNotifier = ref.read(orderSetProvider.notifier);
    final itemIsSaved = useState(false);

    useEffect(() {
      final currentAmount = item.amount;
      final currentTotalPrice = currentAmount * product.price;

      _updateControllerText(amountController, currentAmount);
      _updateControllerText(totalPriceController, currentTotalPrice);

      final originalAmount = order?.products
          .firstWhere(
            (e) => e.product.id == item.product.id,
            orElse: () => item.copyWith(amount: -1),
          )
          .amount;

      itemIsSaved.value = originalAmount == -1 || currentAmount != originalAmount;

      return null;
    }, [item.amount, product.price, order]);

    void updateAmount(num newAmount) {
      if (newAmount <= 0) {
        orderNotifier.deleteItem(item, context);
      } else {
        final updatedItem = item.copyWith(amount: newAmount.toDouble());
        orderNotifier.updateItem(updatedItem);
      }
    }

    void updateTotalPrice(num newTotalPrice) {
      if (product.price <= 0) {
        _updateControllerText(totalPriceController, item.amount * product.price);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Mahsulot narxi 0, umumiy narxni o'zgartirib bo'lmaydi.")),
        );
        return;
      }
      if (newTotalPrice < 0) {
        _updateControllerText(totalPriceController, item.amount * product.price);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Umumiy narx manfiy bo'lishi mumkin emas.")),
        );
        return;
      }
      final newAmount = newTotalPrice / product.price;
      updateAmount(newAmount);
    }

    return AppStateWrapper(builder: (theme, _) {
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
                    : theme.scaffoldBgColor,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppFileImage(name: product.name, path: product.images?.firstOrNull, size: 64),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                product.price.priceUZS,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontFamily: boldFamily),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (!infoView && product.size != null && product.size!.isNotEmpty)
                                Text(product.size ?? '', style: TextStyle(color: theme.secondaryTextColor)),
                              if (!infoView && product.size != null && product.size!.isNotEmpty) SizedBox(width: 16),
                              if (!infoView)
                                SizedBox(
                                  width: 120,
                                  child: TextField(
                                    controller: totalPriceController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    style: TextStyle(color: theme.textColor),
                                    cursorHeight: 16,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "Umumiy narx",
                                      contentPadding: Dis.only(tb: 8, lr: 4),
                                      constraints: const BoxConstraints(maxWidth: 120),
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(24)),
                                        borderSide: BorderSide(color: theme.mainColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(24)),
                                        borderSide: BorderSide(color: theme.mainColor, width: 2.0),
                                      ),
                                    ),
                                    onSubmitted: (text) {
                                      final value = _tryParseNum(text);
                                      if (value != null) {
                                        updateTotalPrice(value);
                                      } else {
                                        _updateControllerText(totalPriceController, item.amount * product.price);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Noto'g'ri narx kiritildi!")),
                                        );
                                      }
                                    },
                                    onTapOutside: (_) {
                                      final value = _tryParseNum(totalPriceController.text);
                                      final currentDisplayedPrice = item.amount * product.price;
                                      // Qiymat valid va o'zgargan bo'lsa yangilaymiz
                                      if (value != null && _formatDecimal(value) != _formatDecimal(currentDisplayedPrice)) {
                                        updateTotalPrice(value);
                                      } else if (value == null && totalPriceController.text.isNotEmpty) {
                                        _updateControllerText(totalPriceController, currentDisplayedPrice);
                                      } else if (value != null && _formatDecimal(value) == _formatDecimal(currentDisplayedPrice)) {
                                        _updateControllerText(totalPriceController, currentDisplayedPrice);
                                      }
                                      FocusScope.of(context).unfocus();
                                    },
                                  ),
                                ),
                              if (infoView)
                                Text(
                                  "${_formatDecimal(item.amount)} × ${product.price.priceUZS}",
                                  style: TextStyle(fontFamily: boldFamily, fontSize: 16),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16.0),
                height: 1,
                width: double.infinity,
                color: theme.accentColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!infoView)
                    Row(
                      children: [
                        WebButton(
                          onPressed: () {
                            updateAmount(item.amount - 1);
                          },
                          builder: (focused) {
                            return Icon(
                              Ionicons.remove_circle_outline,
                              size: 40,
                              color: focused ? theme.mainColor : theme.secondaryTextColor,
                            );
                          },
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 64,
                          child: TextField(
                            controller: amountController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            style: TextStyle(color: theme.textColor),
                            cursorHeight: 16,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Miqdor",
                              contentPadding: Dis.only(tb: 8),
                              constraints: const BoxConstraints(maxWidth: 64),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(24)),
                                borderSide: BorderSide(color: theme.mainColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(24)),
                                borderSide: BorderSide(color: theme.mainColor, width: 2.0),
                              ),
                            ),
                            onSubmitted: (text) {
                              final value = _tryParseNum(text);
                              if (value != null) {
                                updateAmount(value);
                              } else {
                                _updateControllerText(amountController, item.amount);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Noto'g'ri miqdor kiritildi!")),
                                );
                              }
                            },
                            onTapOutside: (_) {
                              final value = _tryParseNum(amountController.text);
                              // Qiymat valid va o'zgargan bo'lsa yangilaymiz
                              if (value != null && _formatDecimal(value) != _formatDecimal(item.amount)) {
                                updateAmount(value);
                              } else if (value == null && amountController.text.isNotEmpty) {
                                _updateControllerText(amountController, item.amount);
                              } else if (value != null && _formatDecimal(value) == _formatDecimal(item.amount)) {
                                // Agar qiymat o'zgarmagan bo'lsa ham formatni to'g'rilaymiz
                                _updateControllerText(amountController, item.amount);
                              }
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        WebButton(
                          onPressed: () {
                            updateAmount(item.amount + 1);
                          },
                          builder: (focused) {
                            return Icon(
                              Ionicons.add_circle_outline,
                              size: 40,
                              color: focused ? theme.mainColor : theme.secondaryTextColor,
                            );
                          },
                        ),
                      ],
                    ),
                  if (!infoView)
                    IconButton(
                      onPressed: () {
                        orderNotifier.deleteItem(item, context);
                      },
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      style: IconButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  if (infoView)
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${AppLocales.total.tr()}:",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            (item.amount * item.product.price).priceUZS,
                            style: TextStyle(fontSize: 18, fontFamily: boldFamily),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
