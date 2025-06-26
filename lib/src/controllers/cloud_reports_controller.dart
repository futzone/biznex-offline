import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/database/employee_database/employee_database.dart';
import 'package:biznex/src/core/database/order_database/order_database.dart';
import 'package:biznex/src/core/database/order_database/order_percent_database.dart';
import 'package:biznex/src/core/database/product_database/product_database.dart';
import 'package:biznex/src/core/database/transactions_database/transactions_database.dart';

class CloudReportsController {
  final WidgetRef ref;
  final BuildContext context;
  final ValueNotifier<double> progress;

  CloudReportsController({
    required this.ref,
    required this.context,
    required this.progress,
  });

  final OrderDatabase _orderDatabase = OrderDatabase();
  final OrderPercentDatabase _orderPercentDatabase = OrderPercentDatabase();
  final EmployeeDatabase _employeeDatabase = EmployeeDatabase();
  final ProductDatabase _productDatabase = ProductDatabase();
  final TransactionsDatabase _transactionsDatabase = TransactionsDatabase();
}
