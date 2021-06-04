import 'package:flutter/material.dart';
import 'package:flutter_web_demo/database/db_context.dart';
import 'package:flutter_web_demo/widgets/pages/base/data_page.dart';

import 'models/customer.dart';
import 'models/order.dart';
import 'models/product.dart';
import 'widgets/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => MyHomePage(title: 'Home'),
        '/customers': (context) => DataPage<Customer>(
              title: 'Customers',
              loadData: DbContext.getCustomers(),
            ),
        '/products': (context) => DataPage<Product>(
              title: 'Products',
              loadData: DbContext.getProducts(),
            ),
        '/orders': (context) => DataPage<Order>(
              title: 'Orders',
              loadData: DbContext.getOrders(),
            ),
      },
    );
  }
}
