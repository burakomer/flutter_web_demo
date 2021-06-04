import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: body(),
    );
  }

  Widget body() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            onPressed: () => Navigator.pushNamed(context, '/customers'),
            child: Text('Customers'),
          ),
          MaterialButton(
            onPressed: () => Navigator.pushNamed(context, '/products'),
            child: Text('Products'),
          ),
          MaterialButton(
            onPressed: () => Navigator.pushNamed(context, '/orders'),
            child: Text('Orders'),
          ),
        ],
      );
}
