import '../database/db_helper.dart';
import '../models/cart_model.dart';

class CartRepository {
  final DbHelper _dbHelper = DbHelper.instance;

  // Retrieve all items in the cart, converted to CartModel objects
  Future<List<CartModel>> getCartItems() async {
    final maps = await _dbHelper.getCartItems();
    return maps.map((map) => CartModel.fromMap(map)).toList();
  }

  // Add an item to the SQLite cart
  Future<int> addToCart(CartModel item) async {
    return await _dbHelper.insertCartItem(item.toMap());
  }

  // Update item quantity in the SQLite cart
  Future<int> updateQuantity(int id, int quantity) async {
    return await _dbHelper.updateCartItem(id, quantity);
  }

  // Remove an item from the SQLite cart
  Future<int> removeFromCart(int id) async {
    return await _dbHelper.deleteCartItem(id);
  }

  // Clear all items in the SQLite cart
  Future<int> clearCart() async {
    return await _dbHelper.clearCart();
  }
}
