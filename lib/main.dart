import 'dart:async';
import 'dart:io';

import 'package:biznex/src/providers/license_status_provider.dart';
import 'package:biznex/src/server/start.dart';
import 'package:biznex/src/ui/screens/sleep_screen/activity_wrapper.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toastification/toastification.dart';
import 'package:window_manager/window_manager.dart';
import 'package:path/path.dart' as path;

bool debugMode = true;
const appVersion = 'v1.0.2';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: Size(1200, 720),
      minimumSize: Size(1200, 720),
      center: true,
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    final appDir = await getApplicationSupportDirectory();
    final dir = Directory(path.join(appDir.path, 'database'));
    Hive.init(dir.path);
    // Hive.initFlutter();

    startServer();
    await EasyLocalization.ensureInitialized();

    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        color: Colors.white,
        child: Center(
          child: SelectableText(
            '❌ UI Error:\n\n${details.exceptionAsString()}\n\n${details.stack}',
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
        ),
      );
    };

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };

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
  }, (error, stack) {
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SelectableText(
            '❌ CATCHED ERROR:\n\n$error\n\n$stack',
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
        ),
      ),
    ));
  });
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
            supportedLocales: context.supportedLocales,
            title: 'Biznex',
            debugShowCheckedModeBanner: false,
            theme: theme.themeData,
            home: ActivityWrapper(child: LicenseStatusWrapper()),
          ),
        );
      },
    );
  }
}
