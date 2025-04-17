import 'dart:developer';

import 'package:biznex/src/core/database/order_database/order_database.dart';
import 'package:biznex/src/core/database/place_database/place_database.dart';
import 'package:biznex/src/server/app_response.dart';
import 'package:biznex/src/server/constants/api_endpoints.dart';
import 'package:biznex/src/server/constants/response_messages.dart';
import 'package:biznex/src/server/database_middleware.dart';
import 'package:biznex/src/server/docs.dart';
import 'package:shelf/src/request.dart';

class OrdersRouter {
  Request request;

  OrdersRouter(this.request);

  DatabaseMiddleware databaseMiddleware(boxName) => DatabaseMiddleware(
        pincode: request.headers['pin']!,
        boxName: boxName,
      );

  OrderDatabase orderDatabase = OrderDatabase();

  Future<AppResponse> getEmployeeOrders() async {
    final employee = await databaseMiddleware(orderDatabase.getBoxName('all')).employeeState();
    if (employee == null) return AppResponse(statusCode: 403, error: ResponseMessages.unauthorized);
    final box = await databaseMiddleware(orderDatabase.getBoxName('all')).openBox();
    List responseList = [];
    for (final item in box.values) {
      if (item['employee']['id'] == employee.id) {
        responseList.add(item);
      }
    }

    return AppResponse(statusCode: 200, data: responseList);
  }

  Future<AppResponse> getPlaceState(String id) async {
    final employee = await databaseMiddleware(orderDatabase.getBoxName('all')).employeeState();
    if (employee == null) return AppResponse(statusCode: 403, error: ResponseMessages.unauthorized);
    final state = await orderDatabase.getPlaceOrder(id);

    return AppResponse(statusCode: 200, data: state?.toJson());
  }

  static ApiRequest orders() => ApiRequest(
        name: 'Get Orders',
        path: ApiEndpoints.orders,
        method: 'GET',
        headers: {'Content-Type': 'application/json', 'pin': 'XXXX'},
        body: '{}',
        contentType: 'application/json',
        errorResponse: {'error': ResponseMessages.unauthorized},
        response: [
          {
            "place": {
              "name": "table 1",
              "id": "950708f0-19fa-11f0-80b6-5b844bb28dff",
              "image": null,
              "children": [],
              "father": {"name": "redy", "id": "8b880130-19fa-11f0-80b6-5b844bb28dff", "image": null, "father": null}
            },
            "id": "8eed1a50-1b5c-11f0-8e81-79294647df32",
            "createdDate": "2025-04-17T12:21:19.707097",
            "updatedDate": "2025-04-17T12:21:19.707097",
            "customer": null,
            "employee": {
              "fullname": "Name",
              "createdDate": "",
              "description": null,
              "phone": "876543234567",
              "id": "40290a10-1796-11f0-8d58-5fe7800001ab",
              "roleName": "Harrom",
              "roleId": "37a1f6e0-1796-11f0-8d58-5fe7800001ab",
              "pincode": "1111"
            },
            "status": "completed",
            "realPrice": null,
            "price": 22590.0,
            "note": "",
            "scheduledDate": null,
            "products": [
              {
                "placeId": "950708f0-19fa-11f0-80b6-5b844bb28dff",
                "product": {
                  "name": "Bulochka",
                  "barcode": "886021044309",
                  "tagnumber": "370C3",
                  "cratedDate": "2025-04-16T14:20:29.475858",
                  "updatedDate": "2025-04-16T14:20:29.474841",
                  "informations": [],
                  "description": "",
                  "images": [],
                  "measure": "gramm",
                  "color": null,
                  "colorCode": null,
                  "size": null,
                  "price": 13440.0,
                  "amount": 213.0,
                  "percent": 12.0,
                  "id": "0a176730-1aa4-11f0-8fa3-998087b4fdae",
                  "productId": null,
                  "variants": null,
                  "category": {"name": "Dessert", "id": "26c32500-1aa3-11f0-8fa3-998087b4fdae", "parentId": null, "printerParams": {}}
                },
                "amount": 1.0,
                "customPrice": null
              },
              {
                "placeId": "950708f0-19fa-11f0-80b6-5b844bb28dff",
                "product": {
                  "name": "Kirvetki",
                  "barcode": "920783232801",
                  "tagnumber": "F4055",
                  "cratedDate": "2025-04-16T14:17:18.133468",
                  "updatedDate": "2025-04-16T14:17:18.132480",
                  "informations": [],
                  "description": "",
                  "images": [],
                  "measure": "gramm",
                  "color": null,
                  "colorCode": null,
                  "size": null,
                  "price": 1100.0,
                  "amount": 123.0,
                  "percent": 10.0,
                  "id": "980aee50-1aa3-11f0-8fa3-998087b4fdae",
                  "productId": null,
                  "variants": null,
                  "category": {"name": "Shurpa", "id": "2a1de8c0-1aa3-11f0-8fa3-998087b4fdae", "parentId": null, "printerParams": {}}
                },
                "amount": 1.0,
                "customPrice": null
              },
              {
                "placeId": "950708f0-19fa-11f0-80b6-5b844bb28dff",
                "product": {
                  "name": "Somsa",
                  "barcode": "308591191324",
                  "tagnumber": "14F9E",
                  "cratedDate": "2025-04-16T14:18:09.060903",
                  "updatedDate": "2025-04-16T14:18:09.059901",
                  "informations": [],
                  "description": "",
                  "images": [],
                  "measure": "gramm",
                  "color": null,
                  "colorCode": null,
                  "size": null,
                  "price": 8050.0,
                  "amount": 123.0,
                  "percent": 15.0,
                  "id": "b665c640-1aa3-11f0-8fa3-998087b4fdae",
                  "productId": null,
                  "variants": null,
                  "category": {"name": "Meal", "id": "2321bb50-1aa3-11f0-8fa3-998087b4fdae", "parentId": null, "printerParams": {}}
                },
                "amount": 1.0,
                "customPrice": null
              }
            ],
            "orderNumber": null
          },
        ],
      );

  static ApiRequest placeState() => ApiRequest(
        name: 'Get Place State',
        path: "${ApiEndpoints.placeOrders}{place_id}",
        method: 'GET',
        headers: {'Content-Type': 'application/json', 'pin': 'XXXX'},
        body: '{}',
        contentType: 'application/json',
        errorResponse: {'error': ResponseMessages.unauthorized},
        response: {
          "place": {
            "name": "table 1",
            "id": "950708f0-19fa-11f0-80b6-5b844bb28dff",
            "image": null,
            "children": [],
            "father": {"name": "redy", "id": "8b880130-19fa-11f0-80b6-5b844bb28dff", "image": null, "father": null}
          },
          "id": "bf3e7570-1b5f-11f0-8c85-1f38c19c7799",
          "createdDate": "2025-04-17T12:44:09.287983",
          "updatedDate": "2025-04-17T12:44:09.287983",
          "customer": null,
          "employee": {
            "fullname": "Name",
            "createdDate": "",
            "description": null,
            "phone": "876543234567",
            "id": "40290a10-1796-11f0-8d58-5fe7800001ab",
            "roleName": "Harrom",
            "roleId": "37a1f6e0-1796-11f0-8d58-5fe7800001ab",
            "pincode": "1111"
          },
          "status": "opened",
          "realPrice": null,
          "price": 53050.0,
          "note": "",
          "scheduledDate": null,
          "products": [
            {
              "placeId": "950708f0-19fa-11f0-80b6-5b844bb28dff",
              "product": {
                "name": "Somsa",
                "barcode": "308591191324",
                "tagnumber": "14F9E",
                "cratedDate": "2025-04-16T14:18:09.060903",
                "updatedDate": "2025-04-16T14:18:09.059901",
                "informations": [],
                "description": "",
                "images": [],
                "measure": "gramm",
                "color": null,
                "colorCode": null,
                "size": null,
                "price": 8050.0,
                "amount": 122.0,
                "percent": 15.0,
                "id": "b665c640-1aa3-11f0-8fa3-998087b4fdae",
                "productId": null,
                "variants": null,
                "category": {"name": "Meal", "id": "2321bb50-1aa3-11f0-8fa3-998087b4fdae", "parentId": null, "printerParams": {}}
              },
              "amount": 1.0,
              "customPrice": null
            },
            {
              "placeId": "950708f0-19fa-11f0-80b6-5b844bb28dff",
              "product": {
                "name": "Sendvich",
                "barcode": "373827905147",
                "tagnumber": "57393",
                "cratedDate": "2025-04-16T14:19:03.460033",
                "updatedDate": "2025-04-16T14:19:03.460033",
                "informations": [],
                "description": "",
                "images": [],
                "measure": "gramm",
                "color": null,
                "colorCode": null,
                "size": null,
                "price": 45000.0,
                "amount": 899.0,
                "percent": 0.0,
                "id": "d6d28e40-1aa3-11f0-8fa3-998087b4fdae",
                "productId": null,
                "variants": null,
                "category": {
                  "name": "Meal",
                  "id": "2321bb50-1aa3-11f0-8fa3-998087b4fdae",
                  "parentId": null,
                  "printerParams": {},
                }
              },
              "amount": 1.0,
              "customPrice": null
            }
          ],
          "orderNumber": "1744875849287"
        },
      );
}
