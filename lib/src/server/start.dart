import 'dart:developer';
import 'package:biznex/src/server/constants/api_endpoints.dart';
import 'package:biznex/src/server/docs.dart';
import 'package:biznex/src/server/routes/categories_router.dart';
import 'package:biznex/src/server/routes/orders_router.dart';
import 'package:biznex/src/server/routes/places_router.dart';
import 'package:biznex/src/server/routes/products_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

void startServer() async {
  log('Server running...');
  final app = Router();

  app.get(ApiEndpoints.docs, (Request request) async {
    return Response.ok(renderApiRequests(), headers: {"Content-Type": "text/html"});
  });

  app.get(ApiEndpoints.places, (Request request) async {
    // final payload = await request.readAsString();
    // final json = jsonDecode(payload);
    // box.put('key', payload);
    PlacesRouter placesRouter = PlacesRouter(request);
    final placesResponse = await placesRouter.getPlaces();
    return placesResponse.toResponse();
  });

  app.get(ApiEndpoints.categories, (Request request) async {
    CategoriesRouter categoriesRouter = CategoriesRouter(request);
    final placesResponse = await categoriesRouter.getCategories();
    return placesResponse.toResponse();
  });

  app.get(ApiEndpoints.products, (Request request) async {
    ProductsRouter categoriesRouter = ProductsRouter(request);
    final placesResponse = await categoriesRouter.getProducts();
    return placesResponse.toResponse();
  });

  app.get(ApiEndpoints.orders, (Request request) async {
    OrdersRouter ordersRouter = OrdersRouter(request);
    final placesResponse = await ordersRouter.getEmployeeOrders();
    return placesResponse.toResponse();
  });

  app.get(ApiEndpoints.placeOrders, (Request request, String id) async {
    OrdersRouter ordersRouter = OrdersRouter(request);
    final placesResponse = await ordersRouter.getPlaceState(id);
    return placesResponse.toResponse();
  });

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(app.call);

  await io.serve(handler, '0.0.0.0', 8080);
}
