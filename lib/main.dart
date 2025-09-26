import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopgoes/firebase_options.dart';
import 'package:shopgoes/model/address_model.dart';
import 'package:shopgoes/model/coupon_model.dart';
import 'package:shopgoes/model/history_model.dart';
import 'package:shopgoes/model/mybag_model.dart';
import 'package:shopgoes/model/myfavorite_model.dart';
import 'package:shopgoes/model/product_model.dart';
import 'package:shopgoes/pages/splash.dart';
import 'package:shopgoes/services/address_service.dart';
import 'package:shopgoes/services/coupon_service.dart';
import 'package:shopgoes/services/history_service.dart';
import 'package:shopgoes/services/mybag_service.dart';
import 'package:shopgoes/services/myfavorite_service.dart';
import 'package:shopgoes/services/product_service.dart';
import 'package:shopgoes/services/sharedservice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedService.init();

  await Hive.initFlutter();

 

  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ReviewAdapter());
  Hive.registerAdapter(AddressAdapter());
  Hive.registerAdapter(MybagAdapter());
  Hive.registerAdapter(MyfavoriteAdapter());
  Hive.registerAdapter(CouponAdapter());
  Hive.registerAdapter(OrderHistoryAdapter());

  await OrderService.init();

  await FavoriteService.init();

  await MybagService.init();

  await CouponService.init();
  await CouponService.seedCoupons();

  await ProductService.init();
  await ProductService.seedProducts();

  await AddressService.init();
  await AddressService.seedAddresses();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: 'Poppins'),

      home: SplashPage(),
    );
  }
}
