import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/config/theme.dart';
import 'package:biznex/src/core/extensions/for_double.dart';
import 'package:biznex/src/ui/screens/settings_screen/settings_screen.dart';
import 'package:biznex/src/ui/widgets/helpers/app_custom_padding.dart';
import 'package:flutter/material.dart';

class SettingsButtonScreen extends StatelessWidget {
  final AppColors theme;
  final AppModel model;
  final bool opened;

  const SettingsButtonScreen({super.key, required this.theme, required this.model, required this.opened});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Dis.all(16),
      padding: Dis.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        // border: Border.all(color: theme.accentColor),
        color: Colors.white.withValues(alpha: 0.12)
      ),
      child: !opened
          ? SettingsScreenButton(theme)
          : Row(
              children: [
                Container(
                  margin: 12.right,
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: theme.accentColor,
                  ),
                  child: Icon(Icons.person, color: theme.textColor),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        model.shopName ?? 'Biznex',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        model.currentEmployee?.fullname ?? 'Admin',
                        style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.w300),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SettingsScreenButton(theme),
              ],
            ),
    );
  }
}
