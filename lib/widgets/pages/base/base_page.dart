import 'package:flutter/material.dart';

abstract class BasePage extends StatefulWidget {
  BasePage({Key? key, required this.title}) : super(key: key);
  final String title;
}

abstract class BaseState<T extends BasePage> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        actions: barActions(),
      ),
      body: body(),
      floatingActionButton: floatingButton(),
    );
  }

  Widget body();

  List<Widget>? barActions() {
    return null;
  }

  Widget? floatingButton() {
    return null;
  }
}
