 import 'package:biznex/src/ui/widgets/helpers/app_custom_padding.dart';
import 'package:flutter/material.dart';

import '../../widgets/helpers/app_loading_screen.dart';

showAppLoadingDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AppLoadingScreen(padding: Dis.all(100));
      });
}

