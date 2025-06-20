import 'package:biznex/src/core/database/changes_database/changes_database.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

export 'package:hive_flutter/hive_flutter.dart';

export 'package:hive/hive.dart';

abstract class AppDatabase {
  Future<void> set({required dynamic data});

  Future<void> update({required String key, required dynamic data});

  Future<dynamic> get();

  Future<dynamic> delete({required String key});

  Future<Box> openBox(String boxName) async {
    final box = await Hive.openBox(boxName);
    return box;
  }

  String get generateID {
    var uuid = Uuid();
    return uuid.v1();
  }

  ChangesDatabase get changesDatabase => ChangesDatabase();
}
