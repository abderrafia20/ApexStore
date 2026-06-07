import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://fakestoreapi.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // Fetch all products from FakeStore API
  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await _dio.get('/products');
      
      if (response.statusCode == 200) {
        if (response.data is List) {
          return response.data as List<dynamic>;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio-specific exceptions with friendly messages
      String errorMessage = 'An error occurred';
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Server response timeout. Please try again later.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please connect to the internet.';
      } else if (e.response != null) {
        errorMessage = 'Server error: ${e.response?.statusCode}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
