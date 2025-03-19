import 'package:biznex/src/core/database/app_database/app_database.dart';
import 'package:biznex/src/core/model/employee_models/employee_model.dart';
 
class EmployeeDatabase extends AppDatabase {
  final String boxName = 'employees';

  @override
  Future delete({required String key}) async {
    final box = await openBox(boxName);
    await box.delete(key);
  }

  @override
  Future<List<Employee>> get() async {
    final box = await openBox(boxName);
    final boxData = box.values;

    final List<Employee> productInfoList = [];
    for (final item in boxData) {
      productInfoList.add(Employee.fromJson(item));
    }

    return productInfoList;
  }

  @override
  Future<void> set({required data}) async {
    if (data is! Employee) return;

    Employee productInfo = data;
    productInfo.id = generateID;

    final box = await openBox(boxName);
    await box.put(productInfo.id, productInfo.toJson());
  }

  @override
  Future<void> update({required String key, required data}) async {
    if (data is! Employee) return;

    final box = await openBox(boxName);
    box.put(key, data.toJson());
  }
}
