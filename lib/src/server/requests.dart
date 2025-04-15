import 'package:biznex/src/server/docs.dart';

List<ApiRequest> serverRequestsList() {
  return [
    ApiRequest(
      name: 'Login',
      path: '/auth/login',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: '{"email": "test@test.com", "password": "123456"}',
      contentType: 'application/json',
      errorResponse: {},
    ),
    ApiRequest(
      name: 'Get User',
      path: '/user/me',
      method: 'GET',
      headers: {},
      body: '',
      contentType: 'application/json',
      errorResponse: {},
    ),
  ];
}
