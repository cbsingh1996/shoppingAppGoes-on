import 'package:hive/hive.dart';
import 'product_model.dart'; // Product model
import 'address_model.dart'; // Address model

part 'history_model.g.dart';

/// Order History Model
@HiveType(typeId: 4)
class OrderHistory extends HiveObject {
  @HiveField(0)
  String orderId;

  @HiveField(1)
  List<Product> products; // 🔥 as it is Product model

  @HiveField(2)
  double totalAmount;

  @HiveField(3)
  String paymentMode;

  @HiveField(4)
  String status; // Pending, Shipped, Delivered, Cancelled

  @HiveField(5)
  DateTime orderDate;

  @HiveField(6)
  Address deliveryAddress; // 🔥 direct Address model use

  @HiveField(7)
  bool useCoupon; // ✅ new field (true/false)

  OrderHistory({
    required this.orderId,
    required this.products,
    required this.totalAmount,
    required this.paymentMode,
    required this.status,
    required this.orderDate,
    required this.deliveryAddress,
    this.useCoupon = false, 
  });
}
