import 'dart:convert';
import 'package:http/http.dart' as http;
import "package:collection/collection.dart";

import '/models/customer.dart';
import '/models/order.dart';
import '/models/order_detail.dart';
import '/models/product.dart';

class DbContext {
  static const BaseUrl = "http://localhost:80/demo";

  // Database Interaction Code

  static Future<List<T>> _request<T>(String table, Map<String, String>? body,
      Future<List<T>> Function(List<Map<String, dynamic>> responseBody)? responseFunc) async {
    var response = await http.post(Uri.parse("$BaseUrl/$table.php"), body: body);

    try {
      //print(response.body);

      var responseBody = (json.decode(response.body) as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      //print(responseBody);

      var list = <T>[];
      if (responseFunc != null) {
        list = await responseFunc(responseBody);
      }
      return list;
    } catch (e) {
      print(e);
      print('Error! Response body is: ' + response.body);
      return [];
    }
  }

  static Future<List<T>> callSP<T>(String table, String spName, Map<String, String>? body,
      Future<List<T>> responseFunc(List<Map<String, dynamic>> responseBody)) async {
    if (body == null) body = {};
    body['action'] = 'call';
    body['procedure'] = spName;

    return await _request<T>(table, body, responseFunc);
  }

  static Future<List<T>> select<T>(String table, Map<String, String>? body,
      Future<List<T>> responseFunc(List<Map<String, dynamic>> responseBody)) async {
    if (body == null) body = {};
    body['action'] = 'select';

    return await _request<T>(table, body, responseFunc);
  }

  static Future<List<T>> insert<T>(String table, Map<String, String>? body,
      Future<List<T>> responseFunc(List<Map<String, dynamic>> responseBody)) async {
    if (body == null) body = {};
    body['action'] = 'insert';

    return await _request<T>(table, body, responseFunc);
  }

  // PRODUCTS

  static Future<List<Product>> getProducts([String condition = '']) async {
    return select('products', {'condition': condition},
        (jsons) async => jsons.map((json) => Product.fromJson(json)).toList());
  }

  // CUSTOMERS

  static Future<List<Customer>> getCustomers([String condition = '']) async {
    return await select('customers', {'condition': condition},
        (jsons) async => jsons.map((json) => Customer.fromJson(json)).toList());
  }

  // ORDERS

  static void createOrder(int customerId, List<Product> products) async {
    var body = {
      "action": "insert",
      "customerid": customerId.toString(),
      "details": jsonEncode(products
          .groupListsBy((product) => product.id)
          .values
          .map((productList) =>
              {"productid": productList[0].id, "quantity": productList.length.toString()})
          .toList())
    };

    await _request<Order>('orders', body, null);
  }

  static Future<List<Order>> getOrders([String condition = '']) async {
    var ordersResponse = (List<Map<String, dynamic>> orders) async {
      final ordersFuture = orders.map((order) async {
        var totalPrice = (await callSP(
                'orders',
                'totalPriceForOrder',
                {"props": order['id']},
                (response) async => await Future.wait(response
                    .map((responseBody) async => double.parse(responseBody['totalprice']))
                    .toList())))
            .first;

        var details = await getOrderDetails(int.parse(order['id']));

        var customer = (await getCustomers('id = ${order['customerid']}')).first;

        return Order(int.parse(order['id']), DateTime.parse(order['orderdate']), totalPrice,
            customer, details);
      }).toList();
      return Future.wait(ordersFuture);
    };

    return await select('orders', {'condition': condition}, ordersResponse);
  }

  static Future<List<OrderDetail>> getOrderDetails(int orderId) async {
    var detailsResponse = (List<Map<String, dynamic>> details) {
      final detailsFuture = details.map((detail) async {
        var product = (await getProducts('id = \'${detail['productid']}\'')).first;
        return OrderDetail.fromJson(detail, product);
      }).toList();
      return Future.wait(detailsFuture);
    };

    return await select<OrderDetail>(
        'orderdetails', {'condition': 'orderid = $orderId'}, detailsResponse);
  }
}
