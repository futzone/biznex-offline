import 'dart:io';

import 'package:biznex/src/core/database/app_database/app_state_database.dart';
import 'package:biznex/src/core/extensions/app_responsive.dart';
import 'package:biznex/src/providers/app_state_provider.dart';
import 'package:biznex/src/providers/printer_devices_provider.dart';
import 'package:biznex/src/ui/widgets/custom/app_custom_popup_menu.dart';
import 'package:biznex/src/ui/widgets/custom/app_file_image.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/custom/app_toast.dart';
import 'package:biznex/src/ui/widgets/helpers/app_decorated_button.dart';
import 'package:biznex/src/ui/widgets/helpers/app_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:printing/printing.dart';
import '../../../../biznex.dart';

class SettingsPageScreen extends HookConsumerWidget {
  const SettingsPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider).value!;
    final nameController = useTextEditingController(text: appState.shopName);
    final printerController = useTextEditingController(text: appState.refresh);
    final phoneController = useTextEditingController(text: appState.printPhone);
    final addressController = useTextEditingController(text: appState.shopAddress);
    final byeTextController = useTextEditingController(text: appState.byeText);
    final printer = useState(Printer(url: appState.token, name: appState.refresh));
    final oldPincodeController = useTextEditingController();
    final newPincodeController = useTextEditingController();

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
                                AppTextField(title: AppLocales.shopNameHint.tr(), controller: nameController, theme: theme),
                                0.h,
                                Text(
                                  AppLocales.shopAddressLabel.tr(),
                                  style: TextStyle(fontSize: 16, fontFamily: mediumFamily),
                                ),
                                AppTextField(title: AppLocales.shopAddressHint.tr(), controller: addressController, theme: theme),
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
                                AppTextField(title: AppLocales.enterPhoneNumber.tr(), controller: phoneController, theme: theme),
                                0.h,
                                Text(
                                  AppLocales.orderCheckByeText.tr(),
                                  style: TextStyle(fontSize: 16, fontFamily: mediumFamily),
                                ),
                                AppTextField(
                                  title: AppLocales.orderCheckByeTextHint.tr(),
                                  controller: byeTextController,
                                  theme: theme,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // 8.h,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 24,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 12,
                              children: [
                                Text(
                                  AppLocales.shopLogoLabel.tr(),
                                  style: TextStyle(fontSize: 16, fontFamily: mediumFamily),
                                ),
                                // AppFileImage(name: name, path: path)
                                SimpleButton(
                                  onPressed: () {
                                    FilePicker.platform.pickFiles().then((file) {
                                      if (file != null && file.files.firstOrNull?.path != null) {
                                        AppModel app = state;
                                        app.imagePath = file.files.first.path;
                                        AppStateDatabase().updateApp(app).then((_) {
                                          ref.refresh(appStateProvider);
                                          ref.invalidate(appStateProvider);
                                        });
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 160,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      // border: Border.all(color: theme.secondaryTextColor),
                                      color: theme.scaffoldBgColor,
                                      image: (state.imagePath == null || (state.imagePath!.isEmpty))
                                          ? null
                                          : DecorationImage(
                                              image: FileImage(File(state.imagePath ?? '')),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    // padding: 24.all,
                                    child: (state.imagePath == null || (state.imagePath!.isEmpty))
                                        ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            spacing: 12,
                                            children: [
                                              Icon(
                                                Iconsax.document_upload,
                                                color: theme.secondaryTextColor,
                                                size: 32,
                                              ),
                                              Text(
                                                AppLocales.uploadImage.tr(),
                                                style: TextStyle(fontFamily: mediumFamily, fontSize: 16),
                                              )
                                            ],
                                          )
                                        : Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              onPressed: () {
                                                AppModel app = state;
                                                app.imagePath = null;
                                                AppStateDatabase().updateApp(app).then((_) {
                                                  ref.refresh(appStateProvider);
                                                  ref.invalidate(appStateProvider);
                                                });
                                              },
                                              icon: Icon(
                                                Ionicons.close_circle_outline,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 80,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 12,
                                  children: [
                                    Text(
                                      AppLocales.printing.tr(),
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
                                                  onPressed: () {
                                                    printer.value = device;
                                                    printerController.text = device.name;
                                                  }),
                                          ],
                                          child: IgnorePointer(
                                            ignoring: true,
                                            child: AppTextField(
                                              prefixIcon: Icon(Iconsax.printer_copy),
                                              onlyRead: true,
                                              title: printer.value.name.isEmpty ? AppLocales.print.tr() : printer.value.name,
                                              controller: printerController,
                                              theme: theme,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                ConfirmCancelButton(
                                  onlyConfirm: true,
                                  confirmText: AppLocales.save.tr(),
                                  onConfirm: () {
                                    AppModel newState = state;

                                    newState.shopName = nameController.text.trim();
                                    newState.printPhone = phoneController.text.trim();
                                    newState.shopAddress = addressController.text.trim();
                                    newState.byeText = byeTextController.text.trim();
                                    newState.token = printer.value.url;
                                    newState.refresh = printer.value.name;

                                    AppStateDatabase().updateApp(newState).then((_) {
                                      ref.refresh(appStateProvider);
                                      ref.invalidate(appStateProvider);

                                      ShowToast.success(context, AppLocales.savedSuccessfully.tr());
                                    });
                                  },
                                ),
                              ],
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
                                  controller: oldPincodeController,
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
                                  controller: newPincodeController,
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
                              onConfirm: () {
                                AppModel newState = state;
                                if (newPincodeController.text.trim().isNotEmpty && oldPincodeController.text.trim() != state.pincode) {
                                  return ShowToast.error(context, AppLocales.incorrectPincode.tr());
                                }

                                if (oldPincodeController.text.trim() == state.pincode && newPincodeController.text.trim().length == 4) {
                                  newState.pincode = newPincodeController.text.trim();
                                }

                                AppStateDatabase().updateApp(newState).then((_) {
                                  ref.refresh(appStateProvider);
                                  ref.invalidate(appStateProvider);
                                  ShowToast.success(context, AppLocales.savedSuccessfully.tr());
                                  newPincodeController.clear();
                                  oldPincodeController.clear();
                                });
                              },
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
