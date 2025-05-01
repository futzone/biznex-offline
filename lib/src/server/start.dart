import 'dart:convert';
import 'dart:developer';
import 'package:biznex/src/server/constants/api_endpoints.dart';
import 'package:biznex/src/server/constants/response_messages.dart';
import 'package:biznex/src/server/docs.dart';
import 'package:biznex/src/server/routes/categories_router.dart';
import 'package:biznex/src/server/routes/employee_router.dart';
import 'package:biznex/src/server/routes/orders_router.dart';
import 'package:biznex/src/server/routes/places_router.dart';
import 'package:biznex/src/server/routes/products_router.dart';
import 'package:biznex/src/server/routes/stats_router.dart';
import 'package:biznex/src/server/services/authorization_services.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

void startServer() async {
  log('Server running...');
  final app = Router();
  final AuthorizationServices authorizationServices = AuthorizationServices();

  app.get(ApiEndpoints.docs, (Request request) async {
    return Response.ok(renderApiRequests(), headers: {"Content-Type": "text/html"});
  });

  app.get(ApiEndpoints.state, (Request request) async {
    final status = authorizationServices.requestAuthChecker(request);
    if (!status) return Response(403, body: jsonEncode({"error": ResponseMessages.unauthorized}));

    StatsRouter statsRouter = StatsRouter(request);
    final placesResponse = await statsRouter.getState();
    return placesResponse.toResponse();
  });

  app.get(ApiEndpoints.employee, (Request request) async {
    final status = authorizationServices.requestAuthChecker(request);
    if (!status) return Response(403, body: jsonEncode({"error": ResponseMessages.unauthorized}));

    EmployeeRouter placesRouter = EmployeeRouter(request);
    final placesResponse = await placesRouter.getCategories();
    return placesResponse.toResponse();
  });

  app.get(ApiEndpoints.places, (Request request) async {
    final status = authorizationServices.requestAuthChecker(request);
    if (!status) return Response(403, body: jsonEncode({"error": ResponseMessages.unauthorized}));

    PlacesRouter placesRouter = PlacesRouter(request);
    final placesResponse = await placesRouter.getPlaces();
    return placesResponse.toResponse();
  });

  app.get(ApiEndpoints.categories, (Request request) async {
    final status = authorizationServices.requestAuthChecker(request);
    if (!status) return Response(403, body: jsonEncode({"error": ResponseMessages.unauthorized}));

    CategoriesRouter categoriesRouter = CategoriesRouter(request);
    final placesResponse = await categoriesRouter.getCategories();
    return placesResponse.toResponse();
  });

  app.get(ApiEndpoints.products, (Request request) async {
    final status = authorizationServices.requestAuthChecker(request);
    if (!status) return Response(403, body: jsonEncode({"error": ResponseMessages.unauthorized}));

    ProductsRouter categoriesRouter = ProductsRouter(request);
    final placesResponse = await categoriesRouter.getProducts();
    return placesResponse.toResponse();
  });

  app.get(ApiEndpoints.orders, (Request request) async {
    final status = authorizationServices.requestAuthChecker(request);
    if (!status) return Response(403, body: jsonEncode({"error": ResponseMessages.unauthorized}));

    OrdersRouter ordersRouter = OrdersRouter(request);
    final placesResponse = await ordersRouter.getEmployeeOrders();
    return placesResponse.toResponse();
  });

  app.get(ApiEndpoints.placeOrders, (Request request, String id) async {
    final status = authorizationServices.requestAuthChecker(request);
    if (!status) return Response(403, body: jsonEncode({"error": ResponseMessages.unauthorized}));

    OrdersRouter ordersRouter = OrdersRouter(request);
    final placesResponse = await ordersRouter.getPlaceState(id);
    return placesResponse.toResponse();
  });

  app.post(ApiEndpoints.orders, (Request request) async {
    final status = authorizationServices.requestAuthChecker(request);
    if (!status) return Response(403, body: jsonEncode({"error": ResponseMessages.unauthorized}));

    OrdersRouter ordersRouter = OrdersRouter(request);
    final placesResponse = await ordersRouter.openOrder(request);
    return placesResponse.toResponse();
  });

  app.put(ApiEndpoints.orders, (Request request) async {
    final status = authorizationServices.requestAuthChecker(request);
    if (!status) return Response(403, body: jsonEncode({"error": ResponseMessages.unauthorized}));

    OrdersRouter ordersRouter = OrdersRouter(request);
    final placesResponse = await ordersRouter.closeOrder(request);
    return placesResponse.toResponse();
  });

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(app.call);
  await io.serve(handler, '0.0.0.0', 8080);
}
