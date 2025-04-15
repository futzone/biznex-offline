import 'package:biznex/src/core/database/place_database/place_database.dart';
import 'package:biznex/src/server/app_response.dart';
import 'package:biznex/src/server/constants/response_messages.dart';
import 'package:biznex/src/server/database_middleware.dart';
import 'package:shelf/src/request.dart';

class PlacesRouter {
  Request request;

  PlacesRouter(this.request);

  DatabaseMiddleware get databaseMiddleware => DatabaseMiddleware(
        pincode: request.headers['pin']!,
        boxName: PlaceDatabase().boxName,
      );

  Future<AppResponse> getPlaces() async {
    final employee = await databaseMiddleware.employeeState();
    if (employee == null) return AppResponse(statusCode: 403, error: ResponseMessages.unauthorized);
    final box = await databaseMiddleware.openBox();
    return AppResponse(statusCode: 200, data: box.values.toList());
  }
}
