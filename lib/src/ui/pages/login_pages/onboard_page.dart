import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/core/model/employee_models/employee_model.dart';
import 'package:biznex/src/providers/employee_provider.dart';
import 'package:biznex/src/ui/pages/login_pages/login_page.dart';
import 'package:biznex/src/ui/widgets/custom/app_error_screen.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/custom/app_text_widgets.dart';
import 'package:biznex/src/ui/widgets/helpers/app_loading_screen.dart';

import '../../screens/onboarding_screens/onboard_card.dart';

class OnboardPage extends ConsumerStatefulWidget {
  const OnboardPage({super.key});

  @override
  ConsumerState<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends ConsumerState<OnboardPage> {
  @override
  Widget build(BuildContext context) {
    return AppStateWrapper(
      builder: (theme, state) {
        return ref.watch(employeeProvider).when(
              error: (error, stackTrace) => AppErrorScreen(),
              loading: () => AppLoadingScreen(),
              data: (employees) {
                if (employees.isEmpty) return LoginPage(model: state, theme: theme);
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Biznex", style: TextStyle(fontSize: 28, fontFamily: boldFamily)),
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Ionicons.close_circle_outline, size: 32),
                      ),
                      8.w,
                    ],
                  ),
                  body: GridView.builder(
                    padding: 16.all,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 2.4,
                    ),
                    itemCount: employees.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return OnboardCard(
                          theme: theme,
                          roleName: "Admin",
                          fullname: "Super Admin",
                          onPressed: () {
                            AppRouter.go(context, LoginPage(model: state, theme: theme));
                          },
                        );
                      }
                      final employee = employees[index - 1];
                      return OnboardCard(
                        theme: theme,
                        roleName: employee.roleName,
                        fullname: employee.fullname,
                        onPressed: () {
                          ref.read(currentEmployeeProvider.notifier).update((state) => employee);
                          AppRouter.go(context, LoginPage(model: state, theme: theme));
                        },
                      );
                    },
                  ),
                );
              },
            );
      },
    );
  }
}
