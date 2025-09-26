import 'package:hive/hive.dart';

part 'coupon_model.g.dart';

@HiveType(typeId: 5) 
class Coupon extends HiveObject {
  @HiveField(0)
  int id; 

  @HiveField(1)
  String code; 

  @HiveField(2)
  double discount; 

  @HiveField(3)
  DateTime expiryDate;

  @HiveField(4)
  bool isActive;

  Coupon({
    required this.id,
    required this.code,
    required this.discount,
    required this.expiryDate,
    this.isActive = true,
  });
}
