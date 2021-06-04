import 'package:flutter_web_demo/models/db_model.dart';

import 'product.dart';

class OrderDetail with DbModel {
  int id;
  int quantity;

  Product product;

  OrderDetail(this.id, this.quantity, this.product);

  factory OrderDetail.fromJson(Map<String, dynamic> json, Product product) {
    return OrderDetail(json['id'] as int, json['quantity'] as int, product);
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'quantity': quantity.toString(),
        'product': product.toJson(),
      };
}
