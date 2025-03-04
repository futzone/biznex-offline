import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/helpers/app_simple_button.dart';
import 'package:flutter/material.dart';

import '../helpers/app_custom_padding.dart';

Future showDesktopModal({required BuildContext context, required Widget body, double? width}) async {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final offset = Tween<Offset>(
        begin: const Offset(1, 0),
        end: const Offset(0, 0),
      ).animate(animation);

      return SlideTransition(
        position: offset,
        child: child,
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.centerRight,
        child: AppCustomDialog(body: body, width: width),
      );
    },
  );
}

class AppCustomDialog extends StatelessWidget {
  final Widget body;
  final double? width;

  const AppCustomDialog({super.key, required this.body, this.width});

  @override
  Widget build(BuildContext context) {
    return AppStateWrapper(builder: (theme, app) {
      return Material(
        color: Colors.transparent,
        elevation: 2,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: width ??
              (app.isDesktop
                  ? MediaQuery.of(context).size.width * 0.3
                  : app.isTablet
                      ? MediaQuery.of(context).size.width * 0.6
                      : MediaQuery.of(context).size.width),
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: app.isMobile
                ? null
                : const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
            color: theme.scaffoldBgColor,
          ),
          child: body,
        ),
      );
    });
  }
}

///printBarcodeWithPrice(
//                                     variant.barcode.toString(),
//                                     product.name,
//                                     ((variant.currentPrice) ?? 0.0),
//                                     height,
//                                     width,
//                                     variant.size?.size ?? '',
//                                   );
