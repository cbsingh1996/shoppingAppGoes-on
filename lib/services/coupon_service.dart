
import 'package:shopgoes/model/coupon_model.dart';
import 'package:hive/hive.dart';

class CouponService{
    static const String couponBoxName = 'coupons';
    
  static Future<void> init() async {
    await Hive.openBox<Coupon>(couponBoxName);
  }

  static Box<Coupon> get _couponBox => Hive.box<Coupon>(couponBoxName);



  static Future<void> seedCoupons({bool reset = false}) async {
    if (reset) await _couponBox.clear();
    if (_couponBox.isEmpty) {
      for (var cop in sampleCoupons) {
        await _couponBox.add(cop );
      }
    }
  }

  static List<Coupon> getCoupons() => _couponBox.values.toList();

  static Future<void> addCoupon(Coupon coupon) async {
    await _couponBox.add(coupon);
  }






}


final List<Coupon> sampleCoupons = [
  Coupon(
    id: 1,
    code: "WELCOME10",
    discount: 10.0, 
    expiryDate: DateTime(2025, 12, 31),
    isActive: true,
  ),
  Coupon(
    id: 2,
    code: "FLAT50",
    discount: 50.0, 
    expiryDate: DateTime(2025, 11, 30),
    isActive: true,
  ),
  Coupon(
    id: 3,
    code: "SUMMER20",
    discount: 20.0, 
    expiryDate: DateTime(2025, 10, 15),
    isActive: true,
  ),
  Coupon(
    id: 4,
    code: "EXPIRED5",
    discount: 5.0, 
    expiryDate: DateTime(2023, 12, 31),
    isActive: false,
  ),
];




