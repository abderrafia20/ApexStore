import 'rating_model.dart';

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final RatingModel rating;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  // Parse product from FakeStoreAPI JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'] as Map<String, dynamic>)
          : RatingModel(rate: 0.0, count: 0),
    );
  }

  // Parse product from SQLite Map (for favorites)
  factory ProductModel.fromDbMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      image: map['image'] as String,
      // The local db doesn't store description, category, or ratings. So we use default values.
      description: '',
      category: '',
      rating: RatingModel(rate: 0.0, count: 0),
    );
  }

  // Convert product to SQLite map for favorites database
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
    };
  }

  // Convert product to standard JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating.toJson(),
    };
  }
}
