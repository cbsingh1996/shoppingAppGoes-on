import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shopgoes/model/product_model.dart';
import 'package:shopgoes/services/mybag_service.dart';

class ProductService {
  static const String productBoxName = 'productsBox';
  static const String idBoxName = 'productIdBox';
  static const String idKey = 'lastProductId';

  static Box<Product> get _productBox => Hive.box<Product>(productBoxName);
  static Box<int> get _idBox => Hive.box<int>(idBoxName);

  // 🔹 ValueNotifier for reactive product count
  static ValueNotifier<int> productCountNotifier = ValueNotifier(0);

  /// Initialize Hive Boxes
  static Future<void> init() async {
    await Hive.openBox<Product>(productBoxName);
    await Hive.openBox<int>(idBoxName);
    _updateNotifier();
  }
static Future<void> clearBoughtProducts(List<Product> boughtProducts) async {
  for (var product in boughtProducts) {
    // 🔹 Step 1: Product ka inBag false karo
    product.inBag = false;
    product.quantity=product.quantity-1;
    await product.save();

    // 🔹 Step 2: MybagService se remove karo
    await MybagService.removeFromBag(product.id);
  }
  _updateNotifier();
}


  /// Update notifier
  static void _updateNotifier() {
    productCountNotifier.value = _productBox.length;
  }

  /// Seed Dummy Data
  static Future<void> seedProducts({bool reset = false}) async {
    if (reset) await _productBox.clear();

    if (_productBox.isEmpty) {
      for (var p in dummyProducts) {
        await _productBox.add(p);
      }
      await _idBox.put(idKey, dummyProducts.length);
    }

    _updateNotifier(); // update reactive count
  }

  /// Add New Product
  static Future<void> addProduct(Product product) async {
    await _productBox.add(product);
    _updateNotifier();
  }

  /// Update Product
  static Future<void> updateProduct(Product product) async {
    await product.save();
    _updateNotifier();
  }

  /// Delete Product
  static Future<void> deleteProduct(int id) async {
    final key = _productBox.keys.firstWhere(
      (k) => _productBox.get(k)!.id == id,
      orElse: () => -1,
    );
    if (key != -1) await _productBox.delete(key);

    _updateNotifier();
  }

  /// Get all products
  static List<Product> getProducts() => _productBox.values.toList();



  /// Dummy Product List for Seeding
  static List<Product> dummyProducts = [
  Product.create(
    id: 1,
    images: ['assets/images/ksb1.1.jpg', 'assets/images/ksb1.2.jpg', 'assets/images/ksb1.3.jpg'],
    keywords: ['kids wear', 'kids zone', 'under 10 years wears', 'shirts', 'black Shirt-1'],
    name: 'Black Shirt-1',
    price: 1500.0,
    quantity: 10,
    detail: 'Feels comfortable when you wear it.',
    category: 'kids',
    offer: 40,
    
  ),
 (() {
    final p = Product.create(
      id: 2,
      images: [
        'assets/images/mpb1.1.jpg',
        'assets/images/mpb1.2.jpg',
        'assets/images/mpb1.3.jpg'
      ],
      keywords: ['man wear', 'pants', 'pagama', 'formal pant'],
      name: 'Formal Pant',
      price: 1200.0,
      quantity: 15,
      detail: 'Pure cotton pant, feel incredible when you wear it.',
      category: 'man',
      offer: 55,
    );

    p.reviewsJson = jsonEncode([
      {
        "userId": "user1",
        "comment": "Quality is very good, worth the price!",
        "rating": 5
      },
      {
        "userId": "user2",
        "comment":'''I have been using this pant for a week now, and I can confidently say it is worth every penny. The fabric is soft,lightweight, and does not cause any discomfort even after wearing it for long hours. The color is rich and stylish, and it has not faded even after multiple washes. The stitching is clean and strong, which makes me believe it will last for a long time. What I like the most is its versatility. I can wear it with a shirt for office meetings or with a casual polo for outings. It perfectly balances formal and casual looks. The fitting is excellent, and it almost feels like it was tailored just for me. Delivery was quick, and the packaging was professional. Many people around me noticed and complimented the pant. Overall, I am very happy with this purchase, and I would recommend it to anyone looking for a reliable and comfortable formal pant at a budget-friendly price.''',
        "rating": 4
      },
      {
        "userId": "user3",
        "comment": "Material is fine but delivery was late.",
        "rating": 3
      },
      {
        "userId": "user4",
        "comment": "Good fabric, very comfortable.",
        "rating": 4
      },
      {
        "userId": "user5",
        "comment": "Not as expected, little tight.",
        "rating": 2
      },
    ]);
    return p;
  })(),
  Product.create(
    id: 3,
    images: ['assets/images/wsy1.1.jpg', 'assets/images/wsy1.2.jpg', 'assets/images/wsy1.3.jpg'],
    keywords: ['women','women cloths', 'suit', 'yellow suit'],
    name: 'Yellow Suit',
    price: 500.0,
    quantity: 100,
    detail: 'Bright yellow suit.',
    category: 'women',
    offer: 10
  ),
  Product.create(
    id: 4,
    images: ['assets/images/ksg1.1.jpg', 'assets/images/ksg1.2.jpg', 'assets/images/ksg1.3.jpg'],
    keywords: ['kids wear', 'kids zone', 'under 10 years wears', 'shirts', 'grey Shirt-1'],
    name: 'Grey Shirt-1',
    price: 1500.0,
    quantity: 10,
    detail: 'Feels comfortable when you wear it.',
    category: 'kids',
    offer: 8
  ),
  Product.create(
    id: 5,
    images: ['assets/images/bn1.webp'],
    keywords: ['bench','wooden bench','platform bench','nelson bench','Nelson Platform Bench'],
    name: 'Nelson Platform Bench',
    price: 180.0,
    quantity: 50,
    detail: 'Designed by George Nelson in 1946, this minimalist bench is known for its clean lines and versatility as both a seat and a table.',
    category: 'furniture',
    offer: 0,
  ),
  Product.create(
    id: 6,
    images: ['assets/images/mp1.1.jpg', 'assets/images/mp1.2.jpg', 'assets/images/mp1.3.jpg'],
    keywords: ['man wear', 'pants', 'pagama', 'formal pant'],
    name: 'Formal Black Pant',
    price: 1200.0,
    quantity: 0,
    detail: 'Pure cotton pant, feel incredible when you wear it.',
    category: 'man',
    offer: 12
  ),
  Product.create(
    id: 7,
    images: ['assets/images/mpg1.1.jpg', 'assets/images/mpg1.2.jpg', 'assets/images/mpg1.3.jpg'],
    keywords: ['man wear', 'pants', 'pagama', 'formal black pant'],
    name: 'Formal Green Pant',
    price: 1200.0,
    quantity: 15,
    detail: 'Pure cotton pant, feel incredible when you wear it.',
    category: 'man',
    offer: 15
  ),
  Product.create(
    id: 8,
    images: ['assets/images/wsb1.1.jpg', 'assets/images/wsb1.2.jpg', 'assets/images/wsb1.3.jpg'],
    keywords: ['women','women cloths', 'suit','black suit'],
    name: 'Black Suit',
    price: 500.0,
    quantity: 100,
    detail: 'Bright Black suit. Its a hand made suit.',
    category: 'women',
    offer: 10
  ),
  Product.create(
    id: 9,
    images: ['assets/images/bn1.webp'],
    keywords: ['bench','wooden bench','platform bench','nelson bench','Nelson Platform Bench'],
    name: 'Nelson Platform Bench',
    price: 1180.0,
    quantity: 50,
    detail: 'Designed by George Nelson in 1946, this minimalist bench is known for its clean lines and versatility as both a seat and a table.',
    category: 'furniture',
    offer: 10,
  ),
  Product.create(
    id: 10,
    images: ['assets/images/ch3.jpg'],
    keywords: ['chair','lounge chair','eames chair','comfortable chair','Eames Lounge Chair'],
    name: 'Eames Lounge Chair',
    price: 11150.0,
    quantity: 40,
    detail: 'Designed by Charles and Ray Eames in 1956, this lounge chair is a symbol of elegance, comfort, and timeless modern design.',
    category: 'furniture',
    offer: 20,
  ),
  Product.create(
    id: 11,
    images: ['assets/images/ch5.jpg'],
    keywords: ['chair','wishbone chair','wegner chair','danish chair','Wishbone Chair'],
    name: 'Wishbone Chair',
    price: 20000.0,
    quantity: 60,
    detail: 'Hans J. Wegner’s Wishbone Chair, created in 1949, is a Danish design classic known for its sculptural form and natural elegance.',
    category: 'furniture',
    offer: 50,
  ),
  Product.create(
    id: 12,
    images: ['assets/images/sf1.jpg'],
    keywords: ['sofa','wooden sofa','3-seater sofa','modern sofa','FPH-Sofa-HT-3s'],
    name: 'FPH-Sofa-HT-3s',
    price: 111500.0,
    quantity: 20,
    detail: 'Manufacturer of solid wood dining table, bookshelf, coffee table, study table, bed, sofa, wardrobe, etc.',
    category: 'furniture',
    offer: 45,
  ),
  Product.create(
    id: 13,
    images: ['assets/images/tb1.jpg'],
    keywords: ['table','coffee table','eames table','wooden table','Eames Coffee Table'],
    name: 'Eames Coffee Table',
    price: 2500.0,
    quantity: 35,
    detail: 'Designed by Charles and Ray Eames, this coffee table blends plywood elegance with timeless modern aesthetics.',
    category: 'furniture',
    offer: 0,
  ),
];
}