import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../repositories/favorite_repository.dart';

class FavoriteViewModel extends ChangeNotifier {
  final FavoriteRepository _favoriteRepository = FavoriteRepository();

  List<ProductModel> _favorites = [];
  bool _isLoading = false;

  // Getters
  List<ProductModel> get favorites => _favorites;
  bool get isLoading => _isLoading;

  // Load all favorite products from SQLite
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _favoriteRepository.getFavorites();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Toggle favorite status of a product (adds or removes)
  Future<void> toggleFavorite(ProductModel product) async {
    try {
      final favorited = isFavorite(product.id);

      if (favorited) {
        // If favorited, remove it
        await _favoriteRepository.removeFavorite(product.id);
      } else {
        // If not favorited, add it
        await _favoriteRepository.addFavorite(product);
      }

      // Reload favorites to update state
      await loadFavorites();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  // Check if a specific product ID is favorited (Synchronous in-memory lookup)
  bool isFavorite(int id) {
    return _favorites.any((product) => product.id == id);
  }

  // Clear all favorite products
  Future<void> clearFavorites() async {
    try {
      await _favoriteRepository.clearFavorites();
      await loadFavorites();
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
    }
  }
}
