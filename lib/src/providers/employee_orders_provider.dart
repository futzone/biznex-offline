import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/database/order_database/order_database.dart';
import 'package:biznex/src/core/model/order_models/order_model.dart';
import 'package:biznex/src/providers/employee_provider.dart';

final FutureProvider<List<Order>> employeeOrdersProvider = FutureProvider((ref) async {
  final employee = ref.watch(currentEmployeeProvider);
  final OrderDatabase orderDatabase = OrderDatabase();
  final allOrders = await orderDatabase.getOrders();

  List<Order> list = [...allOrders.where((el) => el.employee.id == employee.id)];

  list.sort((a, b) {
    final dateA = DateTime.parse(a.updatedDate);
    final dateB = DateTime.parse(b.updatedDate);
    return dateB.compareTo(dateA);
  });

  return list;
});
