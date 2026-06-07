import '../database/db_helper.dart';
import '../models/user_model.dart';

class AuthRepository {
  final DbHelper _dbHelper = DbHelper.instance;

  // Registers a new user and returns their database ID
  Future<int> register(UserModel user) async {
    // Check if email already exists
    final existingUser = await _dbHelper.getUserByEmail(user.email);
    if (existingUser != null) {
      throw Exception('An account with this email already exists.');
    }
    
    // Insert user into SQLite
    return await _dbHelper.insertUser(user.toMap());
  }

  // Logs in a user by comparing email and password
  Future<UserModel?> login(String email, String password) async {
    final userMap = await _dbHelper.getUser(email, password);
    if (userMap != null) {
      return UserModel.fromMap(userMap);
    }
    return null;
  }

  // Retrieves user details by their email address
  Future<UserModel?> getUserByEmail(String email) async {
    final userMap = await _dbHelper.getUserByEmail(email);
    if (userMap != null) {
      return UserModel.fromMap(userMap);
    }
    return null;
  }
}
