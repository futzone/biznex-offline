import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/employee_controller.dart';
import 'package:biznex/src/core/extensions/for_double.dart';
import 'package:biznex/src/core/model/employee_models/role_model.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/custom/app_text_widgets.dart';
import 'package:biznex/src/ui/widgets/helpers/app_decorated_button.dart';
import 'package:biznex/src/ui/widgets/helpers/app_text_field.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddRole extends HookConsumerWidget {
  final Role? role;

  const AddRole({super.key, this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: role?.name);
    return AppStateWrapper(builder: (theme, state) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppText.$18Bold(AppLocales.roleNameLabel.tr(), padding: 8.bottom),
            AppTextField(
              title: AppLocales.roleNameHint.tr(),
              controller: nameController,
              theme: theme,
            ),
            24.h,
            ConfirmCancelButton(
              onConfirm: () {
                EmployeeController employeeController = EmployeeController(context: context, state: state);
                if (role == null) {
                  Role newRole = Role(name: nameController.text.trim());
                  employeeController.createRole(newRole);
                  return;
                }

                Role newRole = role!;
                newRole.name = nameController.text.trim();
                employeeController.updateRole(newRole, role?.id);
              },
            ),
          ],
        ),
      );
    });
  }
}
