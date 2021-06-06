import 'package:flutter/material.dart';
import "package:collection/collection.dart";

import 'package:flutter_web_demo/database/db_context.dart';
import 'package:flutter_web_demo/models/customer.dart';
import 'package:flutter_web_demo/models/order.dart';
import 'package:flutter_web_demo/models/product.dart';
import 'package:flutter_web_demo/widgets/pages/base/base_page.dart';

class CreateOrderPage extends BasePage {
  CreateOrderPage({Key? key}) : super(key: key, title: 'Create Order');

  @override
  _CreateOrderPageState createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends BaseState<CreateOrderPage> {
  final _addProductFormKey = GlobalKey<FormState>();
  final quantityTextForm = TextEditingController();
  late Product selectedProduct;

  final _formKey = GlobalKey<FormState>();

  late Customer customer;

  final List<Product> products = [];

  @override
  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Column(
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  FutureBuilder(
                      future: getCustomers(),
                      builder: (context, AsyncSnapshot<List<DropdownMenuItem<Customer>>> snap) {
                        var items = [DropdownMenuItem<Customer>(child: Text('Nothing'))];
                        if (snap.hasData) {
                          items = snap.data!;
                        }
                        return DropdownButtonFormField<Customer?>(
                          value: null,
                          items: items,
                          hint: Text('Select a Customer'),
                          validator: (Customer? value) {
                            if (value == null) {
                              return 'Please select a customer.';
                            } else
                              return null;
                          },
                          onChanged: (Customer? value) => customer = value!,
                        );
                      }),
                  SizedBox(
                    height: 250.0,
                    child: DataTable(
                        columns: ['Name', 'Quantity', 'Total Price']
                            .map((colName) => DataColumn(label: Text(colName)))
                            .toList(),
                        rows: products
                            .groupListsBy((product) => product.id)
                            .values
                            .map((products) => DataRow(cells: [
                                  DataCell(Text(products[0].name)),
                                  DataCell(Text(products.length.toString())),
                                  DataCell(Text(products
                                      .fold(0.0, (double prev, curr) => curr.price + prev)
                                      .toString())),
                                ]))
                            .toList()),
                  )
                ],
              )),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                onPressed: () => addProductDialog(),
                child: Text('Add Products'),
              )),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget? floatingButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          DbContext.createOrder(customer.id, products);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Created order.')));
          Navigator.pop(context);
        }
      },
      label: Text('Create'),
      icon: Icon(Icons.add),
    );
  }

  Future<List<DropdownMenuItem<Customer>>> getCustomers() async {
    return (await DbContext.getCustomers())
        .map((customer) =>
            DropdownMenuItem<Customer>(child: Text(customer.fullName), value: customer))
        .toList();
  }

  Future<List<DropdownMenuItem<Product>>> getProducts() async {
    return (await DbContext.getProducts())
        .map((product) => DropdownMenuItem<Product>(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(product.name),
                Text(product.price.toString()),
              ],
            ),
            value: product))
        .toList();
  }

  void addProductDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: _addProductFormKey,
            child: SimpleDialog(
              title: Text('Add Products'),
              children: [
                FutureBuilder(
                    future: getProducts(),
                    builder: (context, AsyncSnapshot<List<DropdownMenuItem<Product>>> snap) {
                      var items = [DropdownMenuItem<Product>(child: Text(''))];
                      if (snap.hasData) {
                        items = snap.data!;
                      }
                      return DropdownButtonFormField(
                        items: items,
                        hint: Text('Select a Product to add to the order.'),
                        onChanged: (Product? value) => selectedProduct = value!,
                      );
                    }),
                TextFormField(
                  controller: quantityTextForm,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || int.tryParse(value) == null) {
                      return 'Please enter an integer.';
                    }
                    return null;
                  },
                ),
                MaterialButton(
                  onPressed: () {
                    if (_addProductFormKey.currentState!.validate()) {
                      setState(() {
                        var quantity = int.parse(quantityTextForm.text);
                        for (var i = 0; i < quantity; i++) {
                          products.add(selectedProduct);
                        }
                      });
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Added product.')));
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          );
        });
  }
}
