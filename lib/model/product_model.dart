import 'dart:convert';
import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
class Review {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String comment;

  @HiveField(2)
  int rating;

  Review({
    required this.userId,
    required this.comment,
    required this.rating,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'comment': comment,
        'rating': rating,
      };

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userId: json['userId'],
      comment: json['comment'],
      rating: json['rating'],
    );
  }
}

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String imagesJson;

  @HiveField(2)
  String name;

  @HiveField(3)
  double price;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  String detail;

  @HiveField(6)
  String category;

  @HiveField(7)
  bool isFavorite;

  @HiveField(8)
  bool inBag;

  @HiveField(9)
  int code;

  @HiveField(10)
  int offer;

  @HiveField(11)
  String keywordsJson;

  // ✅ नया field
  @HiveField(12)
  String reviewsJson; // reviews को JSON string में save करेंगे

  Product({
    required this.id,
    required this.imagesJson,
    required this.name,
    required this.price,
    required this.quantity,
    required this.detail,
    required this.category,
    required this.code,
    required this.keywordsJson,
    this.offer = 0,
    this.isFavorite = false,
    this.inBag = false,
    this.reviewsJson = '[]',
  });

  factory Product.create({
    required int id,
    required List<String> images,
    required List<String> keywords,
    required String name,
    required double price,
    required int quantity,
    required String detail,
    required String category,
    int offer = 0,
    bool isFavorite = false,
    bool inBag = false,
    int? code,
  }) {
    return Product(
      id: id,
      imagesJson: jsonEncode(images),
      keywordsJson: jsonEncode(keywords),
      name: name,
      price: price,
      quantity: quantity,
      detail: detail,
      category: category,
      code: code ?? _getCategoryCode(category),
      offer: offer,
      isFavorite: isFavorite,
      inBag: inBag,
      reviewsJson: jsonEncode([]),
    );
  }

  // 🖼 Images
  List<String> get images =>
      (jsonDecode(imagesJson) as List<dynamic>).cast<String>();

  // 🔑 Keywords
  List<String> get keywords =>
      (jsonDecode(keywordsJson) as List<dynamic>).cast<String>();

  // 📝 Reviews
 List<Review> get reviews {
  List<dynamic> decoded;
  try {
    decoded = jsonDecode(reviewsJson);
  } catch (_) {
    decoded = [];
  }

  if (decoded.isEmpty) {
    decoded = [
      {
        'userId': 'Manufacturer',
        'comment': 'No review',
        'rating': 5,
      }
    ];
  }

  return decoded.map((e) => Review.fromJson(e)).toList();
}

  void addReview(Review review) {
    final currentReviews = reviews;
    currentReviews.add(review);
    reviewsJson = jsonEncode(currentReviews.map((r) => r.toJson()).toList());
  }

  // ⭐ Average Rating
  double get averageRating {
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
  }

  static int _getCategoryCode(String category) {
    switch (category.toLowerCase()) {
      case 'man':
        return 0;
      case 'women':
        return 1;
      case 'kids':
        return 2;
      case 'furniture':
        return 3;
      case 'grocery':
        return 4;
      default:
        return -1;
    }
  }
}
