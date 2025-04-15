import 'dart:convert';
import 'dart:developer';
import 'package:biznex/src/server/docs.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:hive/hive.dart';

void startServer() async {
  log('Server running...');
  final app = Router();

  var box = await Hive.openBox('products');

  app.get('/data', (Request request) async {
    final value = box.toMap();
    return Response.ok(jsonEncode(value), headers: {"Content-Type": "application/json"});
  });

  app.get('/docs', (Request request) async {
    return Response.ok(renderApiRequests(), headers: {"Content-Type": "text/html"});
  });

  app.post('/data', (Request request) async {
    final payload = await request.readAsString();
    final json = jsonDecode(payload);
    // box.put('key', payload);
    return Response.ok(jsonEncode(json), headers: {"Content-Type": "application/json"});
  });

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(app);

  final server = await io.serve(handler, '0.0.0.0', 8080);
  print('Server running on localhost:${server.port}');
}
