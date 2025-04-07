import 'dart:developer';

import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/core/database/app_database/app_state_database.dart';
import 'package:biznex/src/core/database/employee_database/role_database.dart';
import 'package:biznex/src/core/model/employee_models/employee_model.dart';
import 'package:biznex/src/core/model/employee_models/role_model.dart';
import 'package:biznex/src/providers/app_state_provider.dart';
import 'package:biznex/src/providers/employee_provider.dart';
import 'package:biznex/src/ui/pages/main_pages/main_page.dart';
import 'package:biznex/src/ui/pages/waiter_pages/waiter_page.dart';
import 'package:biznex/src/ui/widgets/custom/app_text_widgets.dart';
import 'package:biznex/src/ui/widgets/custom/app_toast.dart';

class LoginPage extends ConsumerStatefulWidget {
  final AppModel model;
  final AppColors theme;
  final bool byAdmin;

  const LoginPage({super.key, this.byAdmin = false, required this.model, required this.theme});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  AppModel get model => widget.model;

  AppColors get theme => widget.theme;

  List<String> pincodeChars = ['', '', '', ''];

  void onPressedNumber(String number, String pincode) async {
    for (int i = 0; i < pincodeChars.length; i++) {
      if (pincodeChars[i].isEmpty) {
        pincodeChars[i] = number;
        setState(() {});
        break;
      }
    }
  }

  void onNextPressed(String pincode, Employee employee) async {
    if (!pincodeChars.contains('')) {
      final enteredPin = pincodeChars.join('');

      if (!widget.byAdmin) {
        if (pincode != enteredPin) {
          ShowToast.error(context, AppLocales.incorrectPincode.tr());
          pincodeChars = ['', '', '', ''];
          setState(() {});
        } else {
          final roles = await RoleDatabase().get();
          final role = roles.firstWhere((element) => element.id == employee.roleId);
          log(role.permissions.toString());

          if (role.permissions.contains(Role.permissionList.first) && role.permissions.length == 1) {
            AppRouter.open(context, WaiterPage());
          }
        }
        return;
      }

      AppModel app = model;
      app.pincode = enteredPin;
      AppStateDatabase stateDatabase = AppStateDatabase();
      await stateDatabase.updateApp(app).then((_) {
        model.ref!.invalidate(appStateProvider);
        AppRouter.open(context, MainPage());
      });
    }
  }

  void onDeletePressed() {
    for (int i = 0; i < pincodeChars.length; i++) {
      if (pincodeChars[pincodeChars.length - 1 - i].isNotEmpty) {
        pincodeChars[pincodeChars.length - 1 - i] = '';
        setState(() {});
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentEmployee = ref.watch(currentEmployeeProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocales.enterNewPincode.tr(),
              style: TextStyle(
                fontFamily: boldFamily,
                fontSize: 32,
              ),
            ),
            16.h,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: List.generate(pincodeChars.length, (index) {
                return Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: pincodeChars[index].isEmpty ? theme.secondaryTextColor : theme.mainColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: AppText.$24Bold(pincodeChars[index]),
                  ),
                );
              }),
            ),
            24.h,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                buildNumberButton(onPressed: () => onPressedNumber("1", currentEmployee.pincode), number: "1"),
                buildNumberButton(onPressed: () => onPressedNumber("2", currentEmployee.pincode), number: "2"),
                buildNumberButton(onPressed: () => onPressedNumber("3", currentEmployee.pincode), number: "3"),
              ],
            ),
            16.h,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                buildNumberButton(onPressed: () => onPressedNumber("4", currentEmployee.pincode), number: "4"),
                buildNumberButton(onPressed: () => onPressedNumber("5", currentEmployee.pincode), number: "5"),
                buildNumberButton(onPressed: () => onPressedNumber("6", currentEmployee.pincode), number: "6"),
              ],
            ),
            16.h,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                buildNumberButton(onPressed: () => onPressedNumber("7", currentEmployee.pincode), number: "7"),
                buildNumberButton(onPressed: () => onPressedNumber("8", currentEmployee.pincode), number: "8"),
                buildNumberButton(onPressed: () => onPressedNumber("9", currentEmployee.pincode), number: "9"),
              ],
            ),
            16.h,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                buildNumberButton(onPressed: onDeletePressed, number: "9", icon: Icons.backspace_outlined),
                buildNumberButton(onPressed: () => onPressedNumber("0", currentEmployee.pincode), number: "0"),
                buildNumberButton(
                  onPressed: () => onNextPressed(currentEmployee.pincode, currentEmployee),
                  number: "Go",
                  icon: Icons.arrow_forward_ios_outlined,
                  primary: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNumberButton({required void Function() onPressed, required String number, IconData? icon, bool primary = false}) {
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
