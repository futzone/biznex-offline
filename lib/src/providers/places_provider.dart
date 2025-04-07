import 'package:biznex/biznex.dart';
import 'package:biznex/src/core/database/place_database/place_database.dart';

final placesProvider = FutureProvider((ref)async {
  PlaceDatabase placeDatabase = PlaceDatabase();
  return await placeDatabase.get();
});