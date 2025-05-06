import 'dart:convert';
import 'dart:developer';
import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/providers/employee_provider.dart';
import 'package:biznex/src/core/services/network_services.dart';
import 'package:biznex/src/ui/pages/login_pages/login_page.dart';
import 'package:biznex/src/ui/widgets/custom/app_error_screen.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/helpers/app_loading_screen.dart';
import '../../screens/onboarding_screens/onboard_card.dart';
import 'package:window_manager/window_manager.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
                if (employees.isEmpty) return LoginPageHarom(model: state, theme: theme, fromAdmin: true);
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Biznex", style: TextStyle(fontSize: 28, fontFamily: boldFamily)),
                    actions: [
                      IconButton(
                        onPressed: () async {
                          final status = await windowManager.isFullScreen();
                          await windowManager.setFullScreen(!status);
                        },
                        icon: Icon(Icons.fullscreen, size: 32),
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
                          fullname: "Admin",
                          onPressed: () {
                            AppRouter.go(context, LoginPageHarom(model: state, theme: theme, fromAdmin: true));
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
                          AppRouter.go(context, LoginPageHarom(model: state, theme: theme));
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

class QrAddressView extends ConsumerWidget {
  const QrAddressView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(ipProvider).when(
        data: (ip) {
          if (ip == null) return 0.h;

          log('server address: $ip:8080');
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrImageView(
                  data: ip,
                  version: QrVersions.auto,
                  size: 400.0,
                ),
                16.h,
                SingleChildScrollView(
                  child: Text(
                    "IP: $ip",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        error: RefErrorScreen,
        loading: () => AppLoadingScreen());
  }
}
