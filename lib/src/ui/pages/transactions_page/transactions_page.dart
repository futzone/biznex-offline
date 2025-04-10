import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/transaction_controller.dart';
import 'package:biznex/src/core/model/transaction_model/transaction_model.dart';
import 'package:biznex/src/providers/transaction_provider.dart';
import 'package:biznex/src/ui/screens/order_screens/order_info_screen.dart';
import 'package:biznex/src/ui/widgets/custom/app_empty_widget.dart';
import 'package:biznex/src/ui/widgets/custom/app_state_wrapper.dart';
import 'package:biznex/src/ui/widgets/dialogs/app_custom_dialog.dart';

import 'add_transaction_page.dart';

class TransactionsPage extends HookConsumerWidget {
  final ValueNotifier<AppBar> appbar;
  final ValueNotifier<FloatingActionButton?> floatingActionButton;

  const TransactionsPage(this.floatingActionButton, {super.key, required this.appbar});

  @override
  Widget build(BuildContext context, ref) {
    return AppStateWrapper(builder: (theme, state) {
      return AppScaffold(
        appbar: appbar,
        state: state,
        title: AppLocales.transactions.tr(),
        floatingActionButton: null,
        floatingActionButtonNotifier: floatingActionButton,
        actions: [
          Spacer(),
          AppSimpleButton(
            text: AppLocales.add.tr(),
            icon: Icons.add,
            onPressed: () {
              showDesktopModal(
                context: context,
                body: AddTransactionPage(),
                width: MediaQuery.of(context).size.width * 0.4,
              );
            },
          ),
        ],
        body: Padding(
          padding: 24.lr,
          child: Column(
            children: [
              Container(
                padding: Dis.only(lr: 24, tb: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: theme.sidebarBG,
                ),
                child: Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        AppLocales.createdDate.tr(),
                        style: TextStyle(color: Colors.white),
                        maxLines: 1,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          AppLocales.totalSumm.tr(),
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          AppLocales.note.tr(),
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          AppLocales.paymentType.tr(),
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          AppLocales.employeeNameLabel.tr(),
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: Center(child: Text(''))),
                  ],
                ),
              ),
              Expanded(
                child: state.whenProviderData(
                  provider: transactionProvider,
                  builder: (transactions) {
                    transactions as List<Transaction>;

                    if (transactions.isEmpty) return AppEmptyWidget();

                    return ListView.builder(
                      padding: Dis.only(top: 16, bottom: 200),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final item = transactions[index];
                        return Container(
                          margin: 16.bottom,
                          padding: Dis.only(lr: 24, tb: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: theme.accentColor,
                          ),
                          child: Row(
                            spacing: 16,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  DateFormat('yyyy.MM.dd, HH:mm').format(DateTime.parse(
                                    item.createdDate.isEmpty ? DateTime(2025).toString() : item.createdDate,
                                  )),
                                  style: TextStyle(fontFamily: boldFamily, fontSize: 16),
                                  maxLines: 1,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    item.value.priceUZS,
                                    style: TextStyle(fontFamily: boldFamily, fontSize: 16),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    item.note,
                                    style: TextStyle(fontFamily: boldFamily, fontSize: 16),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    item.paymentType.tr(),
                                    style: TextStyle(fontFamily: boldFamily, fontSize: 16),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    item.employee?.fullname ?? ' - ',
                                    style: TextStyle(fontFamily: boldFamily, fontSize: 16),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Row(
                                    spacing: 16,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton.outlined(
                                        onPressed: () {
                                          TransactionController tController = TransactionController(context: context, state: state);
                                          tController.delete(item.id);
                                        },
                                        icon: Icon(Icons.delete_outline),
                                      ),
                                      IconButton.outlined(
                                        onPressed: () {
                                          showDesktopModal(
                                            context: context,
                                            body: AddTransactionPage(transaction: item),
                                            width: MediaQuery.of(context).size.width * 0.4,
                                          );
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
