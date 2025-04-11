import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/core/database/app_database/app_state_database.dart';
import 'package:biznex/src/core/services/license_services.dart';
import 'package:biznex/src/providers/app_state_provider.dart';
import 'package:biznex/src/ui/pages/login_pages/onboard_page.dart';
import 'package:biznex/src/ui/widgets/custom/app_loading.dart';
import 'package:biznex/src/ui/widgets/custom/app_text_widgets.dart';
import 'package:biznex/src/ui/widgets/custom/app_toast.dart';
import 'package:biznex/src/ui/widgets/helpers/app_decorated_button.dart';
import 'package:biznex/src/ui/widgets/helpers/app_text_field.dart';
import 'package:flutter/services.dart';

class ActivationScreen extends StatefulHookConsumerWidget {
  final AppModel state;
  final AppColors theme;

  const ActivationScreen({super.key, required this.state, required this.theme});

  @override
  ConsumerState<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends ConsumerState<ActivationScreen> {
  AppModel get state => widget.state;
  final TextEditingController _textEditingController = TextEditingController();
  LicenseServices licenseServices = LicenseServices();

  AppColors get theme => widget.theme;
  String deviceId = '';

  void _getDeviceId() async {
    final id = await licenseServices.getDeviceId();
    setState(() {
      deviceId = id ?? '';
    });
  }

  void _verifyLicenseKey() async {
    if (_textEditingController.text.trim().isEmpty) return;


    final key = _textEditingController.text.trim();
    final status = await licenseServices.verifyLicense(key);
    if (status) {
      AppModel newApp = state;
      newApp.licenseKey = key;
      AppStateDatabase().updateApp(newApp).then((_) {
        ref.invalidate(appStateProvider);
      });

      AppRouter.open(context, OnboardPage());
    } else {
      ShowToast.error(context, AppLocales.licenseKeyError.tr(), alignment: Alignment.topCenter);
    }
  }

  @override
  void initState() {
    super.initState();
    _getDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: 24.all,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.accentColor,
          ),
          constraints: BoxConstraints(maxWidth: 600, maxHeight: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              Center(child: AppText.$32Bold(AppLocales.confirmLicenseKey.tr())),
              SimpleButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: deviceId));
                  ShowToast.success(context, AppLocales.copied.tr());
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: theme.scaffoldBgColor,
                  ),
                  padding: Dis.only(lr: 24, tb: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(child: Text(deviceId, style: TextStyle(fontSize: 16))),
                      16.w,
                      Icon(Ionicons.copy_outline),
                    ],
                  ),
                ),
              ),
              AppTextField(
                title: AppLocales.enterKey.tr(),
                controller: _textEditingController,
                theme: theme,
                fillColor: theme.scaffoldBgColor,
                suffixIcon: SimpleButton(
                  child: Icon(Ionicons.clipboard_outline),
                  onPressed: () async {
                    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                    String? clipboardText = clipboardData?.text;
                    _textEditingController.text = clipboardText ?? '';
                    setState(() {});
                  },
                ),
              ),
              AppPrimaryButton(
                theme: theme,
                onPressed: _verifyLicenseKey,
                title: AppLocales.login.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
