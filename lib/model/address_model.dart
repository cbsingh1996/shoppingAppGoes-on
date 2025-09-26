import 'package:hive/hive.dart';

part 'address_model.g.dart';
@HiveType(typeId: 6) // Product = 0, Address = 1, Coupon = 2
class Address extends HiveObject {
  @HiveField(0)
  int id; // 👈 unique id for each address

  @HiveField(1)
  String country;

  @HiveField(2)
  String fullName;

  @HiveField(3)
  String mobileNumber;

  @HiveField(4)
  String houseNumber;

  @HiveField(5)
  String landmark;

  @HiveField(6)
  int pincode; // fix 6 digit (validate form pe karna hoga)

  @HiveField(7)
  String town;

  @HiveField(8)
  String city;

  @HiveField(9)
  String state;



  Address({
    required this.id,
    required this.country,
    required this.fullName,
    required this.mobileNumber,
    required this.houseNumber,
    required this.landmark,
    required this.pincode,
    required this.town,
    required this.city,
    required this.state,

  });
}
