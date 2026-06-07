import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../repositories/cart_repository.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository _cartRepository = CartRepository();

  List<CartModel> _cartItems = [];
  bool _isLoading = false;

  // Getters
  List<CartModel> get cartItems => _cartItems;
  bool get isLoading => _isLoading;

  // Calculates total price of items in the cart
  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Load all cart items from the SQLite database
  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cartItems = await _cartRepository.getCartItems();
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add a product to cart (or increment quantity if already exists)
  Future<void> addToCart(ProductModel product) async {
    try {
      // Check if product is already in the cart
      final existingIndex = _cartItems.indexWhere((item) => item.id == product.id);

      if (existingIndex != -1) {
        // If it exists, increment the quantity
        final existingItem = _cartItems[existingIndex];
        await _cartRepository.updateQuantity(existingItem.id, existingItem.quantity + 1);
      } else {
        // Otherwise, add a new CartModel entry
        final newItem = CartModel(
          id: product.id,
          title: product.title,
          price: product.price,
          image: product.image,
          quantity: 1,
        );
        await _cartRepository.addToCart(newItem);
      }

      // Reload cart items from DB to refresh state
      await loadCart();
    } catch (e) {
      debugPrint('Error adding to cart: $e');
    }
  }

  // Increment item quantity in cart
  Future<void> incrementQuantity(int id) async {
    try {
      final index = _cartItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        final item = _cartItems[index];
        await _cartRepository.updateQuantity(id, item.quantity + 1);
        await loadCart();
      }
    } catch (e) {
      debugPrint('Error incrementing cart quantity: $e');
    }
  }

  // Decrement item quantity in cart (remove if quantity becomes 0)
  Future<void> decrementQuantity(int id) async {
    try {
      final index = _cartItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        final item = _cartItems[index];
        if (item.quantity > 1) {
          await _cartRepository.updateQuantity(id, item.quantity - 1);
        } else {
          // If quantity is 1 and they decrement, remove from cart
          await _cartRepository.removeFromCart(id);
        }
        await loadCart();
      }
    } catch (e) {
      debugPrint('Error decrementing cart quantity: $e');
    }
  }

  // Remove an item entirely from the cart
  Future<void> removeFromCart(int id) async {
    try {
      await _cartRepository.removeFromCart(id);
      await loadCart();
    } catch (e) {
      debugPrint('Error removing from cart: $e');
    }
  }

  // Clear all items in the cart
  Future<void> clearCart() async {
    try {
      await _cartRepository.clearCart();
      await loadCart();
    } catch (e) {
      debugPrint('Error clearing cart: $e');
    }
  }
}
