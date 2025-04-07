import 'package:biznex/biznex.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/custom/app_text_widgets.dart';

class OnboardCard extends StatelessWidget {
  final String roleName;
  final String fullname;
  final void Function() onPressed;
  final AppColors theme;

  const OnboardCard({super.key, required this.roleName, required this.fullname, required this.onPressed, required this.theme});

  @override
  Widget build(BuildContext context) {
    return WebButton(
      onPressed: onPressed,
      builder: (focused) {
        return AnimatedContainer(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: focused ? theme.mainColor.withOpacity(0.1) : theme.accentColor,
              border: Border.all(color: focused ? theme.mainColor : theme.accentColor)),
          duration: theme.animationDuration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              AppText.$24Bold(fullname),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  Icon(Icons.admin_panel_settings_outlined),
                  Text(
                    roleName,
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
