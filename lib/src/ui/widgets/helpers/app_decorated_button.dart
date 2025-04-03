import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/core/config/theme.dart';
import 'package:biznex/src/core/extensions/for_double.dart';
import 'package:flutter/material.dart';

import 'app_simple_button.dart';

class AppPrimaryButton extends StatelessWidget {
  final AppColors theme;
  final String? title;
  final void Function() onPressed;
  final Color? color;
  final Color? textColor;
  final double radius;
  final EdgeInsets? padding;
  final IconData? icon;
  final Widget? child;
  final BorderRadius? borderRadius;

  const AppPrimaryButton({
    super.key,
    this.padding,
    this.child,
    this.radius = 14,
    required this.theme,
    this.title,
    required this.onPressed,
    this.color,
    this.textColor,
    this.icon,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleButton(
      onPressed: onPressed,
      child: Container(
        padding: padding ?? const EdgeInsets.only(top: 12, bottom: 12),
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(radius),
          color: color ?? theme.mainColor,
        ),
        child: Center(
          child: child ??
              (icon != null
                  ? Icon(
                      icon,
                      color: textColor ?? Colors.white,
                      size: 20,
                    )
                  : Text(
                      title ?? '',
                      style: TextStyle(
                        color: textColor ?? Colors.white,
                        fontFamily: 'Medium',
                      ),
                    )),
        ),
      ),
    );
  }
}

class ConfirmCancelButton extends AppStatelessWidget {
  final void Function()? onConfirm;
  final void Function()? onCancel;
  final String? confirmText;
  final String? cancelText;
  final IconData? confirmIcon;
  final IconData? cancelIcon;

  const ConfirmCancelButton({
    super.key,
    this.onConfirm,
    this.onCancel,
    this.confirmText,
    this.cancelText,
    this.confirmIcon,
    this.cancelIcon,
  });

  @override
  Widget builder(context, theme, ref, state) {
    return Row(
      children: [
        Expanded(
          child: AppPrimaryButton(
            theme: theme,
            onPressed: () {
              if (onCancel == null) {
                AppRouter.close(context);
                return;
              }

              onCancel!();
            },
            title: cancelText ?? AppLocales.close.tr(),
            textColor: theme.textColor,
            color: theme.accentColor,
            child: Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (cancelIcon != null)
                  Icon(
                    cancelIcon,
                    size: 20,
                    color: theme.textColor,
                  ),
                Text(cancelText ?? AppLocales.close.tr())
              ],
            ),
          ),
        ),
        state.getSpacing.w,
        Expanded(
          child: AppPrimaryButton(
            theme: theme,
            onPressed: () {
              if (onConfirm == null) {
                AppRouter.close(context);
                return;
              }

              onConfirm!();
            },
            title: confirmText ?? AppLocales.add.tr(),
            child: Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (confirmIcon != null)
                  Icon(
                    confirmIcon,
                    size: 20,
                    color: Colors.white,
                  ),
                Text(
                  confirmText ?? AppLocales.add.tr(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
