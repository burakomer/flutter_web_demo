import 'db_model.dart';
import 'product.dart';

class OrderDetail with DbModel {
  int id;
  int quantity;

  Product product;

  OrderDetail(this.id, this.quantity, this.product);

  factory OrderDetail.fromJson(Map<String, dynamic> json, Product product) {
    return OrderDetail(int.parse(json['id']), int.parse(json['quantity']), product);
  }

  @override
  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity.toString(),
      };
}
