import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/extensions/device_type.dart';
import 'package:biznex/src/ui/pages/monitoring_pages/monitoring_employees_page.dart';
import 'package:biznex/src/ui/pages/monitoring_pages/monitoring_orders_page.dart';
import 'package:biznex/src/ui/pages/monitoring_pages/monitoring_products_page.dart';
import 'package:biznex/src/ui/pages/monitoring_pages/monitoring_transactions_page.dart';
import 'package:biznex/src/ui/screens/chart_screens/chart_screen.dart';
import 'package:biznex/src/ui/screens/chart_screens/chart_screens.dart';
import 'package:biznex/src/ui/screens/monitoring_screen/monitoring_card_screen.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';

class MonitoringPage extends StatefulHookConsumerWidget {
  const MonitoringPage({super.key});

  @override
  ConsumerState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends ConsumerState<MonitoringPage> {
  @override
  Widget build(BuildContext context) {
    return AppStateWrapper(builder: (theme, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(AppLocales.reports.tr(), style: TextStyle(fontSize: 20, fontFamily: boldFamily)),
                ),
                64.w,
              ],
            ),
          ),
          Expanded(
            child: GridView(
              padding: Dis.only(lr: 24, bottom: 200),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: getDeviceType(context) == DeviceType.tablet ? 2.0 : 3.0,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              children: [
                MonitoringCard(
                  theme: theme,
                  title: AppLocales.employees.tr(),
                  onPressed: () {
                    showDesktopModal(
                      width: MediaQuery.of(context).size.width * 0.6,
                      context: context,
                      body: MonitoringEmployeesPage(),
                    );
                  },
                ),
                MonitoringCard(
                  theme: theme,
                  title: AppLocales.products.tr(),
                  onPressed: () {
                    showDesktopModal(
                      width: MediaQuery.of(context).size.width * 0.6,
                      context: context,
                      body: MonitoringProductsPage(),
                    );
                  },
                ),
                MonitoringCard(
                  theme: theme,
                  title: AppLocales.orders.tr(),
                  onPressed: () {
                    showDesktopModal(
                      width: MediaQuery.of(context).size.width * 0.6,
                      context: context,
                      body: MonitoringOrdersPage(),
                    );
                  },
                ),
                MonitoringCard(
                  theme: theme,
                  title: AppLocales.transactions.tr(),
                  onPressed: () {
                    showDesktopModal(
                      width: MediaQuery.of(context).size.width * 0.6,
                      context: context,
                      body: MonitoringTransactionsPage(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
