import 'customer.dart';
import 'db_model.dart';
import 'order_detail.dart';

class Order with DbModel {
  int id;
  DateTime orderDate;
  double totalPrice;

  Customer customer;
  List<OrderDetail> details;

  Order(this.id, this.orderDate, this.totalPrice, this.customer, this.details);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'orderdate': orderDate.toString(),
        'customer': customer.fullName,
        'price': totalPrice.toString(),
        'details': details.map((od) => od.toJson()),
      };
}
