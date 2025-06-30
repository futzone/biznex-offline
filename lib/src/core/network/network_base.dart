import 'dart:developer';
import 'dart:io';

import 'package:biznex/src/core/network/endpoints.dart';
import 'package:biznex/src/core/network/password.dart';
import 'package:dio/dio.dart';

class Network {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 7),
      sendTimeout: const Duration(seconds: 5),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<bool> isConnected() async {
    try {
      final password = await _password();
      if (password.isEmpty || password == '0000') return false;

      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<String> _password() async {
    PasswordDatabase passwordDatabase = PasswordDatabase();
    String? password = await passwordDatabase.getPassword();
    if (password == null || password.isEmpty) {
      password = "0000";
    }
    return password;
  }

  Future<dynamic> get(String url, {Map<String, dynamic>? body, String? password}) async {
    try {
      if (!(await isConnected())) return null;

      final data = await dio.get(
        url,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'password': password ?? await _password(),
          },
        ),
      );
      return data.data;
    } on DioException catch (error, stackTrace) {
      log("Method: GET | Path: $url");
      log("Response:  ${error.response?.data}");
      log("Error:", error: error, stackTrace: stackTrace);
      return null;
    }
  }

  Future<bool> post(String url, {Map<String, dynamic>? body, String? password}) async {
    try {
      if (!(await isConnected())) return false;
      await dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'password': password ?? (await _password()),
          },
        ),
      );
      return true;
    } on DioException catch (error, stackTrace) {
      log(error.requestOptions.headers.toString());
      log("Method: POST | Path: $url, Status: ${error.response?.statusCode}, Headers: ${error.response?.headers}");
      log("Response:  ${error.response?.data}");
      log("Error:", error: error, stackTrace: stackTrace);
      return false;
    }
  }

  Future<bool> delete(String url, {String? password, dynamic body}) async {
    try {
      if (!(await isConnected())) return false;
      await dio.delete(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'password': password ?? await _password(),
          },
        ),
        data: body,
      );
      return true;
    } on DioException catch (error, stackTrace) {
      log("Method: POST | Path: $url");
      log("Response:  ${error.response?.data}");
      log("Error:", error: error, stackTrace: stackTrace);
      return false;
    }
  }

  Future<bool> patch(String url, {Map<String, dynamic>? body, String? password}) async {
    try {
      if (!(await isConnected())) return false;
      await dio.patch(
        url,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'password': password ?? await _password(),
          },
        ),
      );
      return true;
    } on DioException catch (error, stackTrace) {
      log("Method: POST | Path: $url");
      log("Response:  ${error.response?.data}");
      log("Error:", error: error, stackTrace: stackTrace);
      return false;
    }
  }

  Future<bool> put(String url, {Map<String, dynamic>? body, String? password}) async {
    try {
      if (!(await isConnected())) return false;
      await dio.put(
        url,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'password': password ?? await _password(),
          },
        ),
      );
      return true;
    } on DioException catch (error, stackTrace) {
      log("Method: PUT | Path: $url");
      log("Response:  ${error.response?.data}");
      log("Error:", error: error, stackTrace: stackTrace);
      return false;
    }
  }
}
