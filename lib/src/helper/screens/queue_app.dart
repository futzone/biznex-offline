import 'package:biznex/biznex.dart';
import 'package:biznex/src/helper/pages/queue_page.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:toastification/toastification.dart';

class QueueApp extends StatelessWidget {
  final WindowController windowController;
  final Map<String, dynamic> args;

  const QueueApp({super.key, required this.windowController, required this.args});

  @override
  Widget build(BuildContext context) {
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
            home: QueuePage(windowController: windowController, args: args),
          ),
        );
      },
    );
  }
}
