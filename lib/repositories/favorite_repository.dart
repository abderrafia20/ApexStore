import '../database/db_helper.dart';
import '../models/product_model.dart';

class FavoriteRepository {
  final DbHelper _dbHelper = DbHelper.instance;

  // Retrieve all favorite items, converted to ProductModel objects
  Future<List<ProductModel>> getFavorites() async {
    final maps = await _dbHelper.getFavorites();
    return maps.map((map) => ProductModel.fromDbMap(map)).toList();
  }

  // Save a product to favorites database
  Future<int> addFavorite(ProductModel product) async {
    return await _dbHelper.insertFavorite(product.toDbMap());
  }

  // Remove a product from favorites database
  Future<int> removeFavorite(int id) async {
    return await _dbHelper.deleteFavorite(id);
  }

  // Check if a product ID is stored in the favorites database
  Future<bool> isFavorite(int id) async {
    return await _dbHelper.isFavorite(id);
  }

  // Clear all favorites
  Future<int> clearFavorites() async {
    return await _dbHelper.clearFavorites();
  }
}
