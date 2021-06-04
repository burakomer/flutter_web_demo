import 'db_model.dart';
import 'order_detail.dart';

class Order with DbModel {
  int id;
  DateTime orderDate;
  double totalPrice;

  List<OrderDetail> details;

  Order(this.id, this.orderDate, this.totalPrice, this.details);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'orderdate': orderDate.toString(),
        'price': totalPrice.toString(),
        'details': details.map((od) => od.toJson()),
      };
}
