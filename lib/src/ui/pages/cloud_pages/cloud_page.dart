import 'dart:developer';

import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/extensions/app_responsive.dart';
import 'package:biznex/src/core/model/cloud_models/client.dart';
import 'package:biznex/src/providers/app_state_provider.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/helpers/app_decorated_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CloudPage extends HookConsumerWidget {
  const CloudPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppStateWrapper(
      builder: (theme, state) {
        return Scaffold(
          body: state.whenProviderData(
            provider: clientStateProvider,
            builder: (client) {
              if (client == null) return 0.w;

              client as Client;
              log(client.hiddenPassword);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: Dis.only(lr: context.w(24), top: context.h(24)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: context.w(16),
                      children: [
                        Expanded(
                          child: Text(
                            AppLocales.cloudData.tr(),
                            style: TextStyle(
                              fontSize: context.s(24),
                              fontFamily: mediumFamily,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: Dis.only(lr: context.w(16), tb: context.h(8)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: theme.white,
                          ),
                          child: Text(
                            "${AppLocales.lastUpdatedTime.tr()}:  ${DateFormat('yyyy, dd-MMMM, HH:mm', context.locale.languageCode).format(DateTime.parse(client.updatedAt).toLocal())}",
                            style: TextStyle(
                              fontSize: context.s(14),
                              color: Colors.black54,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: Dis.only(lr: context.w(24), top: context.h(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppLocales.cloudAddressForThisAccount.tr(),
                            style: TextStyle(
                              fontSize: context.s(20),
                              color: Colors.black,
                              fontFamily: boldFamily,
                            ),
                          ),
                          16.h,
                          QrImageView(
                            data: "${client.id}#${client.hiddenPassword}",
                            version: QrVersions.auto,
                            size: context.s(400.0),
                          ),
                          16.h,
                          Text(
                            AppLocales.cloudAddressQrCodeDescription.tr(),
                            style: TextStyle(
                              fontSize: context.s(14),
                              fontFamily: regularFamily,
                            ),
                          ),
                          24.h,
                          AppPrimaryButton(
                            theme: theme,
                            onPressed: () {},
                            title: AppLocales.updateCloudData.tr(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
