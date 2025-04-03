import 'dart:io';

import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/product_controller.dart';
import 'package:biznex/src/core/extensions/for_double.dart';
import 'package:biznex/src/core/model/product_models/product_model.dart';
import 'package:biznex/src/ui/screens/products_screens/product_screen.dart';
 import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/custom/app_toast.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';

class ProductCard extends HookConsumerWidget {
  final Product product;
  final bool miniMode;

  const ProductCard(this.product, {super.key, this.miniMode = false});

  @override
  Widget build(BuildContext context, ref) {
    return AppStateWrapper(builder: (theme, state) {
      return WebButton(
        onPressed: () {
          addOrUpdateOrderItem(ref, OrderItem(product: product, amount: 1));
          ShowToast.success(context, AppLocales.productAddedToSet.tr());
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
                child: Center(child: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
              ),
              Expanded(flex: 1, child: Center(child: Text(product.price.priceUZS))),
              Expanded(flex: 1, child: Center(child: Text("${product.amount.price} ${product.measure ?? ''}"))),
              Expanded(flex: 1, child: Center(child: Text(product.size ?? ' - '))),
              if (!miniMode) Expanded(flex: 1, child: Center(child: Text(product.barcode ?? ' - '))),
              if (!miniMode) Expanded(flex: 1, child: Center(child: Text(product.tagnumber ?? ' - '))),
              if (!miniMode)
                Expanded(
                  flex: 1,
                  child: Row(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton.outlined(
                        onPressed: () {
                          showDesktopModal(
                            width: MediaQuery.of(context).size.width * 0.4,
                            context: context,
                            body: ProductScreen(product),
                          );
                        },
                        icon: Icon(Icons.visibility_outlined),
                        color: theme.textColor,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
