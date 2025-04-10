import 'package:biznex/src/core/database/app_database/app_database.dart';
import 'package:biznex/src/core/model/transaction_model/transaction_model.dart';
 
class TransactionsDatabase extends AppDatabase {
  final String boxName = 'transactions';

  @override
  Future delete({required String key}) async {
    final box = await openBox(boxName);
    await box.delete(key);
  }

  @override
  Future<List<Transaction>> get() async {
    final box = await openBox(boxName);
    final boxData = box.values;

    final List<Transaction> productInfoList = [];
    for (final item in boxData) {
      productInfoList.add(Transaction.fromJson(item));
    }

    return productInfoList;
  }

  @override
  Future<void> set({required data}) async {
    if (data is! Transaction) return;

    Transaction productInfo = data;
    productInfo.id = generateID;

    final box = await openBox(boxName);
    await box.put(productInfo.id, productInfo.toJson());
  }

  @override
  Future<void> update({required String key, required data}) async {
    if (data is! Transaction) return;

    final box = await openBox(boxName);
    box.put(key, data.toJson());
  }
}
