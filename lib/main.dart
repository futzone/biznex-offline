import 'package:biznex/src/ui/pages/login_pages/login_page.dart';
import 'package:biznex/src/ui/pages/login_pages/onboard_page.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toastification/toastification.dart';

bool debugMode = true;
const appVersion = 'v1.0.0';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.initFlutter();

  // startServer();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('uz', 'UZ'),
        Locale('en', 'US'),
      ],
      fallbackLocale: const Locale('uz', 'UZ'),
      path: 'assets/localization',
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return AppStateWrapper(
      mainContext: context,
      builder: (theme, app) {
        return ToastificationWrapper(
          child: MaterialApp(
            locale: context.locale,
            localizationsDelegates: context.localizationDelegates,
            title: 'Biznex',
            debugShowCheckedModeBanner: false,
            theme: theme.themeData,
            home: app.pincode.isEmpty ? LoginPage(model: app, theme: theme, byAdmin: true) : OnboardPage(),
          ),
        );
      },
    );
  }
}
