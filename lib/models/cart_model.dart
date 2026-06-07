class CartModel {
  final int id;
  final String title;
  final double price;
  final String image;
  final int quantity;

  CartModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
  });

  // Create a copy of this object with updated fields (e.g. updating quantity)
  CartModel copyWith({
    int? id,
    String? title,
    double? price,
    String? image,
    int? quantity,
  }) {
    return CartModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
    );
  }

  // Parse Cart item from SQLite Map query
  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'] as int,
      title: map['title'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      image: map['image'] as String? ?? '',
      quantity: map['quantity'] as int? ?? 1,
    );
  }

  // Convert Cart model to SQLite Map for inserts and updates
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }
}
