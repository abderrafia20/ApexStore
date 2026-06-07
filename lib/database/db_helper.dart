import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  // Static instance of DbHelper for singleton pattern (only one instance exists in the app)
  static final DbHelper instance = DbHelper._init();

  static Database? _database;

  // Private constructor
  DbHelper._init();

  // Getter to initialize or retrieve the database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('ecommerce.db');
    return _database!;
  }

  // Opens/creates the database on the device
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create SQLite tables when the database is created for the first time
  Future _createDB(Database db, int version) async {
    // 1. Create Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    // 2. Create Cart table (id stores the product id directly)
    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        image TEXT NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');

    // 3. Create Favorites table (id stores the product id directly)
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        image TEXT NOT NULL
      )
    ''');
  }

  // ==================== USERS OPERATIONS ====================

  // Insert a new user into SQLite (Registration)
  Future<int> insertUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('users', row);
  }

  // Get user details by email and password (Login)
  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await instance.database;
    final results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  // Check if email exists in database
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await instance.database;
    final results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  // ==================== CART OPERATIONS ====================

  // Get all items in the cart
  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await instance.database;
    return await db.query('cart');
  }

  // Add an item to cart or increment its quantity if already exists
  Future<int> insertCartItem(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(
      'cart',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace, // Replaces if matching ID already exists
    );
  }

  // Update product quantity in cart
  Future<int> updateCartItem(int id, int quantity) async {
    final db = await instance.database;
    return await db.update(
      'cart',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Remove a product from cart
  Future<int> deleteCartItem(int id) async {
    final db = await instance.database;
    return await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Clear all items in cart
  Future<int> clearCart() async {
    final db = await instance.database;
    return await db.delete('cart');
  }

  // ==================== FAVORITES OPERATIONS ====================

  // Get all favorite products
  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await instance.database;
    return await db.query('favorites');
  }

  // Add a product to favorites
  Future<int> insertFavorite(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(
      'favorites',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Remove a product from favorites
  Future<int> deleteFavorite(int id) async {
    final db = await instance.database;
    return await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Check if product is favorited
  Future<bool> isFavorite(int id) async {
    final db = await instance.database;
    final results = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty;
  }

  // Clear all favorites
  Future<int> clearFavorites() async {
    final db = await instance.database;
    return await db.delete('favorites');
  }

  // Close the database connection
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
