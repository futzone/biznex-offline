import 'dart:developer';

import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/core/database/app_database/app_state_database.dart';
import 'package:biznex/src/core/database/employee_database/role_database.dart';
import 'package:biznex/src/core/model/employee_models/employee_model.dart';
import 'package:biznex/src/core/model/employee_models/role_model.dart';
import 'package:biznex/src/providers/app_state_provider.dart';
import 'package:biznex/src/providers/employee_provider.dart';
import 'package:biznex/src/ui/pages/login_pages/login_half_page.dart';
import 'package:biznex/src/ui/pages/main_pages/main_page.dart';
import 'package:biznex/src/ui/pages/waiter_pages/waiter_page.dart';
import 'package:biznex/src/ui/widgets/custom/app_text_widgets.dart';
import 'package:biznex/src/ui/widgets/custom/app_toast.dart';
import 'package:biznex/src/ui/widgets/helpers/app_decorated_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_keyboard/pin_keyboard.dart';

class LoginPageHarom extends ConsumerStatefulWidget {
  final AppModel model;
  final AppColors theme;
  final void Function()? onSuccessEnter;
  final bool fromAdmin;

  const LoginPageHarom({
    super.key,
    this.onSuccessEnter,
    required this.model,
    required this.theme,
    this.fromAdmin = false,
  });

  @override
  ConsumerState<LoginPageHarom> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPageHarom> {
  String _pincode = '';
  final FocusNode _focusNode = FocusNode();

  AppModel get model => widget.model;

  AppColors get theme => widget.theme;

  void onNextPressed(String pincode, Employee employee) async {
    await Future.delayed(Duration(milliseconds: 100));
    if (_pincode.length == 4) {
      final enteredPin = _pincode;

      if (model.pincode.isEmpty && employee.roleName.toLowerCase() == 'admin') {
        final app = model..pincode = enteredPin;
        await AppStateDatabase().updateApp(app);
        model.ref!.invalidate(appStateProvider);
        return AppRouter.open(context, MainPage());
      }

      if (widget.fromAdmin && model.pincode == enteredPin) {
        return AppRouter.open(context, MainPage());
      }

      if (!widget.fromAdmin) {
        if (pincode != enteredPin) {
          log("$pincode!= $enteredPin");
          ShowToast.error(context, AppLocales.incorrectPincode.tr());
          _pincode = '';
          return setState(() {});
        }

        final roles = await RoleDatabase().get();
        final role = roles.firstWhere(
          (e) => e.id == employee.roleId,
          orElse: () => Role(name: 'Demo', permissions: []),
        );

        if (role.permissions.contains(Role.permissionList.first) && role.permissions.length == 1) {
          return AppRouter.open(context, WaiterPage());
        }
      }

      if (model.pincode == enteredPin && widget.onSuccessEnter != null) {
        widget.onSuccessEnter!();
        return AppRouter.close(context);
      }


      if(employee.roleName.toLowerCase() == 'admin' && pincode == enteredPin) {
        return AppRouter.open(context, MainPage());
      }

      ShowToast.error(context, AppLocales.incorrectPincode.tr());
      _pincode = '';
      return setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentEmployee = ref.watch(currentEmployeeProvider);
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (RawKeyEvent keyEvent) {
        if (keyEvent is RawKeyDownEvent) {
          final key = keyEvent.logicalKey.keyLabel;

          if (int.tryParse(key) != null && _pincode.length < 4) {
            setState(() {
              _pincode += key;
              if (_pincode.length == 4) {
                Future.microtask(() {
                  onNextPressed(currentEmployee.pincode, currentEmployee);
                });
              }
            });
          }
        }
      },
      child: Scaffold(
        body: Row(
          children: [
            LoginHalfPage(model),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  spacing: 24,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/Vector 614.png', width: 160),
                    Text(
                      model.pincode.isEmpty ? AppLocales.enterNewPincode.tr() : AppLocales.enterPincode.tr(),
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: mediumFamily,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 16,
                      children: List.generate(4, (index) {
                        return Container(
                          height: 68,
                          width: 68,
                          decoration: BoxDecoration(
                            color: theme.accentColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: !(index < _pincode.length)
                              ? null
                              : Icon(
                                  Icons.circle,
                                  color: theme.mainColor,
                                ),
                        );
                      }),
                    ),
                    PinKeyboard(
                      maxWidth: MediaQuery.of(context).size.width * 0.3,
                      space: MediaQuery.of(context).size.height * 0.1,
                      textColor: widget.theme.textColor,
                      length: 4,
                      enableBiometric: false,
                      iconBackspaceColor: widget.theme.textColor,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      onChange: (pin) {
                        setState(() {
                          _pincode = pin;
                        });
                      },
                      onConfirm: (pin) {
                        Future.microtask(() {
                          onNextPressed(currentEmployee.pincode, currentEmployee);
                        });
                      },
                      // onBiometric: () {},
                    ),
                    0.h,
                    AppPrimaryButton(
                      theme: theme,
                      onPressed: () {
                        onNextPressed(currentEmployee.pincode, currentEmployee);
                      },
                      child: Row(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocales.login.tr(),
                            style: TextStyle(
                              fontFamily: mediumFamily,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNumberButton({
    required void Function() onPressed,
    required String number,
    IconData? icon,
    bool primary = false,
  }) {
    return SimpleButton(
      onPressed: onPressed,
      child: Container(
        width: 160,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: number.isEmpty
              ? null
              : primary
                  ? theme.mainColor
                  : theme.accentColor,
        ),
        child: Center(
          child: icon == null
              ? AppText.$24Bold(number)
              : Icon(
                  icon,
                  color: primary ? Colors.white : null,
                ),
        ),
      ),
    );
  }
}
