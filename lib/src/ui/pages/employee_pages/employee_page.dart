import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/extensions/for_double.dart';
import 'package:biznex/src/ui/screens/employee_screens/employee_reponsive.dart';
import 'package:biznex/src/ui/screens/employee_screens/role_responsive.dart';
import 'package:biznex/src/ui/widgets/custom/app_list_tile.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';
import 'package:biznex/src/ui/widgets/helpers/app_text_field.dart';
import 'package:ionicons/ionicons.dart';
import '../../widgets/helpers/app_simple_button.dart';

class EmployeePage extends AppStatelessWidget {
  final ValueNotifier<AppBar> appbar;
  final ValueNotifier<FloatingActionButton?> floatingActionButton;

  const EmployeePage(this.floatingActionButton, {super.key, required this.appbar});

  @override
  Widget builder(BuildContext context, AppColors theme, WidgetRef ref, AppModel state) {
    return AppScaffold(
      appbar: appbar,
      state: state,
      title: AppLocales.employees.tr(),
      floatingActionButton: null,
      floatingActionButtonNotifier: floatingActionButton,
      actions: [
        if (state.isDesktop) 160.w,
        if (state.isDesktop)
          Expanded(
            child: AppTextField(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Ionicons.search_outline),
              ),
              suffixIcon: Padding(
                padding: 8.lr,
                child: IconButton(
                  icon: Icon(Ionicons.filter_outline),
                  onPressed: () {},
                ),
              ),
              title: AppLocales.searchBarHint.tr(),
              controller: TextEditingController(),
              theme: theme,
              enabledColor: theme.secondaryTextColor,
            ),
          ),
        if (!state.isDesktop)
          AppSimpleButton(
            text: AppLocales.search.tr(),
            icon: Icons.search,
            onPressed: () {},
          ),
      ],
      body: state.isMobile
          ? Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppListTile(
              title: AppLocales.employees.tr(),
              theme: theme,
              leadingIcon: Icons.person,
              trailingIcon: Icons.arrow_forward_ios_outlined,
              onPressed: () {
                showDesktopModal(
                  context: context,
                  body: RoleResponsive(useBack: true),
                );
              },
            ),
            AppListTile(
              title: AppLocales.roles.tr(),
              theme: theme,
              leadingIcon: Icons.admin_panel_settings_outlined,
              trailingIcon: Icons.arrow_forward_ios_outlined,
              onPressed: () {
                showDesktopModal(
                  context: context,
                  body: EmployeeReponsive(useBack: true),
                );
              },
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Row(
          spacing: 24,
          children: [
            Expanded(child: RoleResponsive()),
            Container(
              height: double.infinity,
              width: 2,
              color: theme.accentColor,
            ),
            Expanded(child: EmployeeReponsive()),
          ],
        ),
      ),
    );
  }
}
