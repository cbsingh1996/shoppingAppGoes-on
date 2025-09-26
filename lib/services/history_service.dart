import 'package:shopgoes/model/address_model.dart';
import 'package:shopgoes/model/history_model.dart';
import 'package:shopgoes/model/product_model.dart';
import 'package:hive/hive.dart';

class OrderService {
  static const String boxName = 'orderHistoryBox';

  /// Initialize Hive Box
  static Future<void> init() async {
    await Hive.openBox<OrderHistory>(boxName);
  }

  /// Get Hive Box
  static Future<Box<OrderHistory>> _openBox() async {
    return await Hive.openBox<OrderHistory>(boxName);
  }

  /// Auto-generate OrderId
  static Future<String> _generateOrderId() async {
    final box = await _openBox();
    return "ORD${box.length + 1}";
  }

  /// Add new order (status default "Delivered")
  static Future<void> addOrder({
    required List<Product> products,
    required double totalAmount,
    required String paymentMode,
    required DateTime orderDate,
    required Address deliveryAddress,
  }) async {
    final box = await _openBox();

    final order = OrderHistory(
      orderId: await _generateOrderId(),
      products: products,
      totalAmount: totalAmount,
      paymentMode: paymentMode,
      status: "Delivered", // 👈 fixed
      orderDate: orderDate,
      deliveryAddress: deliveryAddress,
    );

    await box.add(order);
  }

  /// Get all orders
  static Future<List<OrderHistory>> getAllOrders() async {
    final box = await _openBox();
    return box.values.toList();
  }

  /// Get order by index (or id)
  static Future<OrderHistory?> getOrderAt(int index) async {
    final box = await _openBox();
    if (index < 0 || index >= box.length) return null;
    return box.getAt(index);
  }

  /// Clear all orders
  static Future<void> clearOrders() async {
    final box = await _openBox();
    await box.clear();
  }
}
