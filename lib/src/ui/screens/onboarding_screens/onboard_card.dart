import 'dart:ui';

import 'package:biznex/biznex.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/custom/app_text_widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class OnboardCard extends StatelessWidget {
  final String roleName;
  final String fullname;
  final void Function() onPressed;
  final AppColors theme;

  const OnboardCard({super.key, required this.roleName, required this.fullname, required this.onPressed, required this.theme});

  @override
  Widget build(BuildContext context) {
    return WebButton(
      onPressed: onPressed,
      builder: (focused) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaY: 56,
              sigmaX: 56,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withValues(alpha: 0.2),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 2,
                ),
              ),
              // duration: theme.animationDuration,
              padding: 16.all,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 16,
                children: [
                  Container(
                    padding: 10.all,
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.44),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Iconsax.security_user_copy,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    fullname,
                    style: TextStyle(
                      fontFamily: mediumFamily,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      Text(
                        roleName,
                        style: TextStyle(
                          fontFamily: mediumFamily,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Text(
                        AppLocales.login.tr(),
                        style: TextStyle(
                          fontFamily: mediumFamily,
                          fontSize: 16,
                          color: theme.mainColor,
                        ),
                      ),
                      Icon(
                        Iconsax.arrow_right_1_copy,
                        color: theme.mainColor,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
