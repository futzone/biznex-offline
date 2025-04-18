import 'dart:convert';

import 'package:shelf/src/response.dart';

class AppResponse {
  String? error;
  String? message;
  int statusCode;
  dynamic data;

  AppResponse({
    required this.statusCode,
    this.data,
    this.error,
    this.message,
  });

  Response toResponse() {
    if (statusCode >= 200 && statusCode <= 299) {
      if (message != null && data == null) {
        return Response(statusCode, body: jsonEncode({"message": message}));
      }
      return Response.ok(jsonEncode(data));
    }

    return Response(statusCode, body: jsonEncode({'error': error}));
  }
}
