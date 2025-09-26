import 'package:flutter/material.dart';
import 'package:shopgoes/model/myfavorite_model.dart';
import 'package:hive/hive.dart';

class FavoriteService {
  static const String boxName = 'favoriteBox';

  // 🔹 ValueNotifier for reactive favorites
  static ValueNotifier<int> favoriteCountNotifier = ValueNotifier(0);

  /// Initialize Hive box and notifier (call in main.dart)
  static Future<void> init() async {
    await Hive.openBox<Myfavorite>(boxName);
    await _updateNotifier();
  }

  static Future<Box<Myfavorite>> _openBox() async {
    return await Hive.openBox<Myfavorite>(boxName);
  }

  /// 🔹 Update notifier from Hive
  static Future<void> _updateNotifier() async {
    final box = await _openBox();
    favoriteCountNotifier.value = box.length;
  }

  /// Add productId to favorites (with duplicate check)
  static Future<void> addToFavorites(int productId) async {
    final box = await _openBox();
    if (!box.values.any((item) => item.productId == productId)) {
      await box.add(Myfavorite(productId: productId));
      await _updateNotifier(); // update reactive notifier
    }
  }

  /// Remove productId (first match)
  static Future<void> removeFromFavorites(int productId) async {
    final box = await _openBox();
    for (var key in box.keys) {
      final item = box.get(key);
      if (item != null && item.productId == productId) {
        await box.delete(key);
        break;
      }
    }
    await _updateNotifier(); // update reactive notifier
  }

  /// Get all productIds in favorites
  static Future<List<int>> getAllFavoriteIds() async {
    final box = await _openBox();
    return box.values.map((e) => e.productId).toList();
  }

  /// Check if a productId exists in favorites
  static Future<bool> isFavorite(int productId) async {
    final box = await _openBox();
    return box.values.any((item) => item.productId == productId);
  }

  /// Clear all favorites
  static Future<void> clearFavorites() async {
    final box = await _openBox();
    await box.clear();
    await _updateNotifier(); // update reactive notifier
  }
}
