import 'package:biznex/src/core/extensions/app_responsive.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import '../../../../biznex.dart';

class SettingsPageScreen extends HookConsumerWidget {
  const SettingsPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppStateWrapper(
      builder: (theme, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: Dis.only(lr: context.w(24), top: context.h(24)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: context.w(16),
                    children: [
                      Expanded(
                        child: Text(
                          AppLocales.settings.tr(),
                          style: TextStyle(
                            fontSize: context.s(24),
                            fontFamily: mediumFamily,
                            color: Colors.black,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
