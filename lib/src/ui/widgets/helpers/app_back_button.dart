import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/core/extensions/app_responsive.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../biznex.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppColors(isDark: false);
    return SimpleButton(
      onPressed: () => AppRouter.close(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(48),
          color: Color(0xffEDFEF5),
          border: Border.all(color: theme.mainColor),
        ),
        height: context.s(48),
        width: context.s(48),
        child: Center(
          child: Icon(
            Iconsax.arrow_left_2_copy,
            color: theme.mainColor,
            size: context.s(24),
          ),
        ),
      ),
    );
  }
}
