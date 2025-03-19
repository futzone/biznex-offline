import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/database/employee_database/employee_database.dart';
import 'package:biznex/src/core/database/employee_database/role_database.dart';
import 'package:biznex/src/core/model/employee_models/employee_model.dart';
import 'package:biznex/src/core/model/employee_models/role_model.dart';

final FutureProvider employeeProvider = FutureProvider<List<Employee>>((ref) async {
  EmployeeDatabase employeeDatabase = EmployeeDatabase();
  return await employeeDatabase.get();
});

final FutureProvider roleProvider = FutureProvider<List<Role>>((ref) async {
  RoleDatabase roleDatabase = RoleDatabase();
  return await roleDatabase.get();
});
