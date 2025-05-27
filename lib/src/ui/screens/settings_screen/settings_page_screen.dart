import 'package:biznex/src/core/extensions/app_responsive.dart';
import 'package:biznex/src/providers/printer_devices_provider.dart';
import 'package:biznex/src/ui/widgets/custom/app_custom_popup_menu.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/helpers/app_decorated_button.dart';
import 'package:biznex/src/ui/widgets/helpers/app_text_field.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:printing/printing.dart';
import '../../../../biznex.dart';

class SettingsPageScreen extends HookConsumerWidget {
  const SettingsPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppStateWrapper(
      builder: (theme, state) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: context.w(24).lr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: Dis.only(tb: context.h(24)),
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
                Container(
                  padding: context.s(20).all,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    color: Colors.white,
                  ),
                  child: Column(
                    spacing: 24,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocales.settings.tr(),
                        style: TextStyle(
                          fontSize: context.s(24),
                          fontFamily: mediumFamily,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        spacing: 24,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 12,
                              children: [
                                Text(
                                  AppLocales.shopName.tr(),
                                  style: TextStyle(fontSize: 16, fontFamily: mediumFamily),
                                ),
                                AppTextField(title: AppLocales.shopNameHint.tr(), controller: TextEditingController(), theme: theme),
                                0.h,
                                Text(
                                  AppLocales.shopAddressLabel.tr(),
                                  style: TextStyle(fontSize: 16, fontFamily: mediumFamily),
                                ),
                                AppTextField(title: AppLocales.shopAddressHint.tr(), controller: TextEditingController(), theme: theme),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 12,
                              children: [
                                Text(
                                  AppLocales.phoneForPrintLabel.tr(),
                                  style: TextStyle(fontSize: 16, fontFamily: mediumFamily),
                                ),
                                AppTextField(title: AppLocales.enterPhoneNumber.tr(), controller: TextEditingController(), theme: theme),
                                0.h,
                                Text(
                                  AppLocales.orderCheckByeText.tr(),
                                  style: TextStyle(fontSize: 16, fontFamily: mediumFamily),
                                ),
                                AppTextField(
                                  title: AppLocales.orderCheckByeTextHint.tr(),
                                  controller: TextEditingController(),
                                  theme: theme,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 24,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 12,
                              children: [
                                Text(
                                  AppLocales.orderCheckByeText.tr(),
                                  style: TextStyle(fontSize: 16, fontFamily: mediumFamily),
                                ),
                                state.whenProviderData(
                                  provider: printerDevicesProvider,
                                  builder: (devices) {
                                    devices as List<Printer>;
                                    return CustomPopupMenu(
                                      theme: theme,
                                      children: [
                                        for (final device in devices)
                                          CustomPopupItem(
                                            title: device.name,
                                            icon: Iconsax.printer_copy,
                                          ),
                                      ],
                                      child: IgnorePointer(
                                        ignoring: true,
                                        child: AppTextField(
                                          prefixIcon: Icon(Iconsax.printer_copy),
                                          onlyRead: true,
                                          title: AppLocales.print.tr(),
                                          controller: TextEditingController(),
                                          theme: theme,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: ConfirmCancelButton(
                              onlyConfirm: true,
                              confirmText: AppLocales.save.tr(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                24.h,
                Container(
                  padding: context.s(20).all,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 24,
                    children: [
                      Text(
                        AppLocales.employeePasswordLabel.tr(),
                        style: TextStyle(
                          fontSize: context.s(24),
                          fontFamily: mediumFamily,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        spacing: 24,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 12,
                              children: [
                                Text(
                                  AppLocales.oldPincodeLabel.tr(),
                                  style: TextStyle(fontSize: 16, fontFamily: mediumFamily),
                                ),
                                AppTextField(
                                  title: AppLocales.oldPincodeHint.tr(),
                                  controller: TextEditingController(),
                                  theme: theme,
                                  maxLength: 4,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 12,
                              children: [
                                Text(
                                  AppLocales.newPincodeLabel.tr(),
                                  style: TextStyle(fontSize: 16, fontFamily: mediumFamily),
                                ),
                                AppTextField(
                                  title: AppLocales.enterNewPincode.tr(),
                                  controller: TextEditingController(),
                                  theme: theme,
                                  maxLength: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(flex: 3, child: SizedBox()),
                          Expanded(
                            flex: 3,
                            child: ConfirmCancelButton(
                              onlyConfirm: true,
                              confirmText: AppLocales.save.tr(),
                            ),
                          ),
                        ],
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
