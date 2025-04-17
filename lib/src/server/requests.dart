import 'package:biznex/src/server/constants/api_endpoints.dart';
import 'package:biznex/src/server/constants/response_messages.dart';
import 'package:biznex/src/server/docs.dart';
import 'package:biznex/src/server/routes/categories_router.dart';
import 'package:biznex/src/server/routes/places_router.dart';
import 'package:biznex/src/server/routes/products_router.dart';

List<ApiRequest> serverRequestsList() {
  return [
    PlacesRouter.docs(),
    CategoriesRouter.docs(),
    ProductsRouter.docs(),
  ];
}
