import 'package:biznex/biznex.dart';
import 'package:biznex/src/controllers/transaction_controller.dart';
import 'package:biznex/src/core/config/router.dart';
import 'package:biznex/src/core/model/transaction_model/transaction_model.dart';
import 'package:biznex/src/providers/employee_provider.dart';
import 'package:biznex/src/ui/widgets/custom/app_custom_popup_menu.dart';
import 'package:biznex/src/ui/widgets/custom/app_text_widgets.dart';
import 'package:biznex/src/ui/widgets/helpers/app_decorated_button.dart';
import 'package:biznex/src/ui/widgets/helpers/app_text_field.dart';
import '../../widgets/custom/app_state_wrapper.dart';

class AddTransactionPage extends HookConsumerWidget {
  final Transaction? transaction;

  const AddTransactionPage({super.key, this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceController = useTextEditingController(text: transaction?.value.toString());
    final noteController = useTextEditingController(text: transaction?.note);
    final selectedMethod = useState(transaction?.paymentType ?? Transaction.cash);
    return AppStateWrapper(builder: (theme, state) {
      return Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              SimpleButton(
                child: Icon(Icons.arrow_back_ios),
                onPressed: () => AppRouter.close(context),
              ),
              16.w,
              AppText.$18Bold(AppLocales.addTransactionLabel.tr())
            ],
          ),
          0.h,
          AppTextField(
            title: AppLocales.addNote.tr(),
            controller: noteController,
            theme: theme,
            maxLines: 3,
          ),
          Row(
            spacing: 16,
            children: [
              Expanded(
                child: AppTextField(
                  title: AppLocales.summ.tr(),
                  controller: priceController,
                  theme: theme,
                ),
              ),
              Expanded(
                child: CustomPopupMenu(
                  children: [
                    for (final item in Transaction.values)
                      CustomPopupItem(
                        title: item.tr(),
                        onPressed: () => selectedMethod.value = item,
                      )
                  ],
                  theme: theme,
                  child: IgnorePointer(
                    ignoring: true,
                    child: AppTextField(
                      onlyRead: true,
                      title: AppLocales.paymentType.tr(),
                      controller: TextEditingController(text: selectedMethod.value.tr()),
                      theme: theme,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: AppPrimaryButton(
                  theme: theme,
                  onPressed: () {
                    TransactionController transactionController = TransactionController(context: context, state: state);
                    Transaction kTransaction = Transaction(
                      value: double.tryParse(priceController.text.trim()) ?? 0.0,
                      paymentType: selectedMethod.value,
                      note: noteController.text.trim(),
                      employee: ref.watch(currentEmployeeProvider),
                    );

                    if (transaction == null) {
                      transactionController.create(kTransaction).then((_) {
                        AppRouter.close(context);
                      });

                      return;
                    }

                    kTransaction.paymentType = selectedMethod.value;
                    kTransaction.note = noteController.text.trim();
                    kTransaction.value = double.tryParse(priceController.text.trim()) ?? 0.0;
                    kTransaction.createdDate = DateTime.now().toIso8601String();
                    transactionController.update(kTransaction, transaction?.id).then((_) {
                      AppRouter.close(context);
                    });
                  },
                  title: AppLocales.add.tr(),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
