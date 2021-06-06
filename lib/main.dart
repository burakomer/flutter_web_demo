import 'package:flutter/material.dart';

import 'widgets/pages/home_page.dart';
import 'widgets/pages/base/data_page.dart';
import 'database/db_context.dart';
import 'models/customer.dart';
import 'models/order.dart';
import 'models/product.dart';
import 'widgets/pages/order/create_order_page.dart';

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
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => MyHomePage(title: 'Home'),
        '/customers': (context) => DataPage<Customer>(
              title: 'Customers',
              getData: DbContext.getCustomers,
            ),
        '/products': (context) => DataPage<Product>(
              title: 'Products',
              getData: DbContext.getProducts,
            ),
        '/orders': (context) =>
            DataPage<Order>(title: 'Orders', getData: DbContext.getOrders, createData: true),
        '/orders/create': (context) => CreateOrderPage(),
      },
    );
  }
}
