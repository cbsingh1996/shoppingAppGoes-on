import 'package:flutter/material.dart';
import 'package:shopgoes/model/mybag_model.dart';
import 'package:hive/hive.dart';

class MybagService {
  static const String boxName = 'mybagBox';

  // 🔹 ValueNotifier for reactive bag
  static ValueNotifier<int> bagCountNotifier = ValueNotifier(0);

  /// Initialize Hive box and notifier
  static Future<void> init() async {
    await Hive.openBox<Mybag>(boxName);
    await _updateNotifier();
  }

  static Future<Box<Mybag>> _openBox() async {
    return await Hive.openBox<Mybag>(boxName);
  }

  /// 🔹 Update notifier from Hive
  static Future<void> _updateNotifier() async {
    final box = await _openBox();
    bagCountNotifier.value = box.length;
  }

  /// Add productId to bag (only if not already present)
  static Future<void> addToBag(int productId) async {
    final box = await _openBox();
    final exists = box.values.any((item) => item.productId == productId);
    if (!exists) {
      await box.add(Mybag(productId: productId));
      await _updateNotifier(); // update reactive notifier
    }
  }

  /// Remove productId 
  static Future<void> removeFromBag(int productId) async {
    final box = await _openBox();
    for (var key in box.keys) {
      final item = box.get(key);
      if (item != null && item.productId == productId) {
        await box.delete(key);
        
      }
    }
    await _updateNotifier(); // update reactive notifier
  }

  /// Get all productIds in bag
  static Future<List<int>> getAllProductIds() async {
    final box = await _openBox();
    return box.values.map((e) => e.productId).toList();
  }

  /// Clear whole bag
  static Future<void> clearBag() async {
    final box = await _openBox();
    await box.clear();
    await _updateNotifier(); // update reactive notifier
  }
}
