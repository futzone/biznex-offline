import 'package:biznex/src/core/database/app_database/app_database.dart';
import 'package:biznex/src/core/model/place_models/place_model.dart';
 
class PlaceDatabase extends AppDatabase {
  final String boxName = 'places';

  @override
  Future delete({required String key}) async {
    final box = await openBox(boxName);
    await box.delete(key);
  }

  @override
  Future<List<Place>> get() async {
    final box = await openBox(boxName);
    final boxData = box.values;

    final List<Place> productInfoList = [];
    for (final item in boxData) {
      productInfoList.add(Place.fromJson(item));
    }

    return productInfoList;
  }

  @override
  Future<void> set({required data}) async {
    if (data is! Place) return;

    Place productInfo = data;
    productInfo.id = generateID;

    final box = await openBox(boxName);
    await box.put(productInfo.id, productInfo.toJson());
  }

  @override
  Future<void> update({required String key, required data}) async {
    if (data is! Place) return;

    final box = await openBox(boxName);
    box.put(key, data.toJson());
  }
}
