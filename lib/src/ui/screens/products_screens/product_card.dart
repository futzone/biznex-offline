import 'dart:io';

import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/extensions/app_responsive.dart';
import 'package:biznex/src/core/model/product_models/product_model.dart';
import 'package:biznex/src/ui/screens/products_screens/product_screen.dart';
import 'package:biznex/src/ui/widgets/custom/app_file_image.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/custom/app_toast.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ProductCard extends HookConsumerWidget {
  final Product product;
  final bool miniMode;

  const ProductCard(this.product, {super.key, this.miniMode = false});

  @override
  Widget build(BuildContext context, ref) {
    final orderNotifier = ref.read(orderSetProvider.notifier);
    return AppStateWrapper(builder: (theme, state) {
      return WebButton(
        onPressed: () {
          // orderNotifier.addItem(OrderItem(product: product, amount: amount, placeId: placeId))
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

class ProductCardNew extends StatelessWidget {
  final Product product;
  final AppColors colors;
  final void Function() onPressed;

  const ProductCardNew({
    super.key,
    required this.product,
    required this.colors,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleButton(
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.all(context.s(8)),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(context.s(12)),
        ),
        child: Column(
          spacing: context.h(8),
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Stack(
                children: [
                  AppFileImage(
                    name: product.name,
                    path: product.images?.firstOrNull,
                    color: colors.scaffoldBgColor,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: context.s(8).all,
                      margin: context.s(8).all,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black.withValues(alpha: 0.36),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: context.w(8),
                        children: [
                          Icon(Iconsax.reserve_copy, color: Colors.white, size: context.s(24)),
                          Text(
                            "${product.amount.toMeasure} ${product.measure ?? ''}",
                            style: TextStyle(
                              fontSize: context.s(16),
                              fontFamily: mediumFamily,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: TextStyle(
                      fontSize: context.s(20),
                      fontFamily: mediumFamily,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                12.w,
                Text(
                  product.price.priceUZS,
                  style: TextStyle(
                    fontSize: context.s(16),
                    fontFamily: mediumFamily,
                    color: colors.mainColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            if (product.description != null && (product.description ?? '').isNotEmpty)
              Text(
                product.description ?? '',
                style: TextStyle(
                  fontSize: context.s(12),
                  fontFamily: regularFamily,
                  color: colors.secondaryTextColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            Row(
              spacing: context.w(8),
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.scaffoldBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: context.s(8).all,
                    child: Row(
                      spacing: context.w(4),
                      children: [
                        Icon(Icons.numbers, size: context.s(18), color: Colors.black),
                        Expanded(
                          child: Text(
                            product.barcode.toString(),
                            style: TextStyle(fontFamily: mediumFamily, color: Colors.black, fontSize: context.s(14)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: colors.scaffoldBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: context.s(8).all,
                  child: Row(
                    spacing: context.w(4),
                    children: [
                      Icon(Ionicons.receipt_outline, size: context.s(18), color: Colors.black),
                      Text(
                        product.tagnumber.toString(),
                        style: TextStyle(
                          fontFamily: mediumFamily,
                          color: Colors.black,
                          fontSize: context.s(14),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
