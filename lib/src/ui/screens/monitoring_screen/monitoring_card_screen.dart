import 'package:biznex/biznex.dart';

class MonitoringCard extends StatelessWidget {
  final AppColors theme;
  final String title;
  final void Function() onPressed;

  const MonitoringCard({
    super.key,
    required this.theme,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.accentColor,
        ),
        padding: 16.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 20, fontFamily: boldFamily)),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 8,
              children: [
                Text(
                  AppLocales.more.tr(),
                  style: TextStyle(fontSize: 16, fontFamily: boldFamily, color: theme.mainColor),
                ),
                Icon(Icons.arrow_forward, color: theme.mainColor),
              ],
            )
          ],
        ),
      ),
    );
  }
}
