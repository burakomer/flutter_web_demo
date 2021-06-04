import 'db_model.dart';

class Customer with DbModel {
  int id;
  String firstName;
  String lastName;
  DateTime registerDate;
  String address;

  Customer(
      this.id, this.firstName, this.lastName, this.registerDate, this.address);

  factory Customer.fromJson(Map<String, dynamic> map) {
    return Customer(int.parse(map['id']), map['firstname'], map['lastname'],
        DateTime.parse(map['registerdate']), map['address']);
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'firstname': firstName,
        'lastname': lastName,
        'registerdate': registerDate.toString(),
        'address': address
      };
}
