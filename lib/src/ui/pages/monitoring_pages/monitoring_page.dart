import 'package:biznex/biznex.dart';
import 'package:biznex/src/providers/employee_provider.dart';
import 'package:biznex/src/providers/products_provider.dart';
import 'package:biznex/src/providers/transaction_provider.dart';
import 'package:biznex/src/core/extensions/app_responsive.dart';
import 'package:biznex/src/providers/employee_orders_provider.dart';
import 'package:biznex/src/core/model/order_models/order_filter_model.dart';
import 'package:biznex/src/ui/pages/monitoring_pages/monitoring_transactions_page.dart';
import 'package:biznex/src/ui/pages/monitoring_pages/monitoring_employees_page.dart';
import 'package:biznex/src/ui/screens/monitoring_screen/monitoring_card_screen.dart';
import 'package:biznex/src/ui/pages/monitoring_pages/monitoring_products_page.dart';
import 'package:biznex/src/ui/pages/monitoring_pages/monitoring_orders_page.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:sliver_tools/sliver_tools.dart';

class MonitoringPage extends StatefulHookConsumerWidget {
  const MonitoringPage({super.key});

  @override
  ConsumerState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends ConsumerState<MonitoringPage> {
  final _filter = OrderFilterModel();

  @override
  Widget build(BuildContext context) {
    return AppStateWrapper(
      builder: (theme, state) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverPinnedHeader(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.scaffoldBgColor,
                  ),
                  padding: Dis.only(lr: context.w(24), tb: context.h(24)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: context.w(16),
                    children: [
                      Expanded(
                        child: Text(
                          AppLocales.reports.tr(),
                          style: TextStyle(
                            fontSize: context.s(24),
                            fontFamily: mediumFamily,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      0.w,
                    ],
                  ),
                ),
              ),
              SliverPadding(
                  padding: Dis.only(lr: context.w(24)),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      spacing: context.h(24),
                      children: [
                        Row(
                          spacing: context.w(24),
                          children: [
                            Expanded(
                              child: state.whenProviderData(
                                provider: employeeProvider,
                                builder: (emp) {
                                  return MonitoringCard(
                                    count: emp.length,
                                    icon: Iconsax.profile_2user,
                                    theme: theme,
                                    title: AppLocales.employees.tr(),
                                    onPressed: () {
                                      showDesktopModal(
                                        width: MediaQuery.of(context).size.width * 0.6,
                                        context: context,
                                        body: MonitoringEmployeesPage(),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: state.whenProviderData(
                                provider: productsProvider,
                                builder: (prd) {
                                  return MonitoringCard(
                                    count: prd.length,
                                    icon: Iconsax.reserve,
                                    theme: theme,
                                    title: AppLocales.products.tr(),
                                    onPressed: () {
                                      showDesktopModal(
                                        width: MediaQuery.of(context).size.width * 0.6,
                                        context: context,
                                        body: MonitoringProductsPage(),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: context.w(24),
                          children: [
                            Expanded(
                              child: state.whenProviderData(
                                provider: ordersFilterProvider(_filter),
                                builder: (ord) {
                                  return MonitoringCard(
                                    count: ord.length,
                                    icon: Iconsax.bag_happy,
                                    theme: theme,
                                    title: AppLocales.orders.tr(),
                                    onPressed: () {
                                      showDesktopModal(
                                        width: MediaQuery.of(context).size.width * 0.6,
                                        context: context,
                                        body: MonitoringOrdersPage(),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: state.whenProviderData(
                                provider: transactionProvider,
                                builder: (trs) {
                                  return MonitoringCard(
                                    icon: Iconsax.send_sqaure_2,
                                    theme: theme,
                                    title: AppLocales.transactions.tr(),
                                    onPressed: () {
                                      showDesktopModal(
                                        width: MediaQuery.of(context).size.width * 0.6,
                                        context: context,
                                        body: MonitoringTransactionsPage(),
                                      );
                                    },
                                    count: trs.length,
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
