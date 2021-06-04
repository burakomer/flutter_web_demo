import 'dart:convert';
import 'package:http/http.dart' as http;

import '/models/customer.dart';
import '/models/order.dart';
import '/models/order_detail.dart';
import '/models/product.dart';

class DbContext {
  static const BaseUrl = "http://localhost:80/demo";

  // Database Interaction Code

  static Future<List<T>> _request<T>(String table, Map<String, String>? body,
      Future<List<T>> jsonFunc(List<Map<String, dynamic>> jsons)) async {
    try {
      var response =
          await http.post(Uri.parse("$BaseUrl/$table.php"), body: body);

      //print(response.body);

      final dynamicList = json.decode(response.body) as List<dynamic>;
      var jsons = dynamicList.map((e) => e as Map<String, dynamic>).toList();

      print(jsons);

      var list = await jsonFunc(jsons);

      return list;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<T>> callSP<T>(
      String table,
      String spName,
      Map<String, String>? headers,
      Future<List<T>> jsonFunc(List<Map<String, dynamic>> jsons)) async {
    if (headers == null) headers = {};
    headers['action'] = 'call';
    headers['spName'] = spName;

    return await _request<T>(table, headers, jsonFunc);
  }

  static Future<List<T>> getFromDb<T>(
      String table,
      Map<String, String>? headers,
      Future<List<T>> jsonFunc(List<Map<String, dynamic>> jsons)) async {
    if (headers == null) headers = {};
    headers['action'] = 'get';

    return await _request<T>(table, headers, jsonFunc);
  }

  // PRODUCTS

  static Future<List<Product>> getProducts([String condition = '']) async {
    return getFromDb('products', {'condition': condition},
        (jsons) async => jsons.map((json) => Product.fromJson(json)).toList());
  }

  // CUSTOMERS

  static Future<List<Customer>> getCustomers([String condition = '']) async {
    return await getFromDb('customers', {'condition': condition},
        (jsons) async => jsons.map((json) => Customer.fromJson(json)).toList());
  }

  // ORDERS

  static Future<List<Order>> getOrders([String condition = '']) async {
    var detailsDecode = (List<Map<String, dynamic>> details) {
      final detailsFuture = details.map((detail) async {
        var product = (await getProducts('id = ${detail['productid']}')).first;
        return OrderDetail.fromJson(detail, product);
      }).toList();
      return Future.wait(detailsFuture);
    };

    var ordersDecode = (List<Map<String, dynamic>> jsons) async {
      final ordersFuture = jsons.map((order) async {
        var details = await getFromDb<OrderDetail>('orderdetails',
            {'condition': 'orderid = ${order['id']}'}, detailsDecode);
        var totalPrice = (await callSP(
                'orders',
                'totalPrice',
                null,
                (jsons) async => await Future.wait(jsons
                    .map((e) async => e['totalPrice'] as double)
                    .toList())))
            .first;

        return Order(order['id'], order['orderdate'], totalPrice, details);
      }).toList();
      return Future.wait(ordersFuture);
    };

    return await getFromDb('orders', {'condition': condition}, ordersDecode);
  }
}
