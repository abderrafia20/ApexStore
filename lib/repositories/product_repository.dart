import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductRepository {
  final ApiService _apiService = ApiService();

  // Fetches products from API and parses them into a list of ProductModel
  Future<List<ProductModel>> getProducts() async {
    final rawProducts = await _apiService.fetchProducts();
    
    // Convert raw JSON maps to ProductModel objects
    return rawProducts.map((json) => ProductModel.fromJson(json)).toList();
  }
}
