import 'db_model.dart';

class Product with DbModel {
  String id;
  String name;
  double price;

  Product(this.id, this.name, this.price);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(json['id'], json['name'], double.parse(json['price']));
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price.toString(),
      };
}
