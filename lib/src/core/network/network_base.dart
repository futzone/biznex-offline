import 'dart:io';

import 'package:biznex/src/core/network/password.dart';
import 'package:dio/dio.dart';

class Network {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 7),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 7),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<bool> isConnected() async {
    try {
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

  Future<bool> get(String url, {Map<String, dynamic>? body, String? password}) async {
    try {
      if (!(await isConnected())) return false;

      await dio.get(
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
    } catch (e) {
      return false;
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
            'password': password ?? await _password(),
          },
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> delete(String url, {String? password}) async {
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
      );
      return true;
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
      return false;
    }
  }
}
