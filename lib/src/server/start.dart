import 'dart:convert';
import 'dart:developer';
import 'dart:io';
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

  app.post('/data', (Request request) async {
    final payload = await request.readAsString();
    box.put('key', payload);
    return Response.ok('saved');
  });

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(app);

  final server = await io.serve(handler, '0.0.0.0', 8080);
  print('Server running on localhost:${server.port}');
}
