import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'database_manager.dart';

class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final List<int> favorites;
  final List<int> cart;
  final String? profilePicPath;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.favorites,
    required this.cart,
    this.profilePicPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'favorites': jsonEncode(favorites),
      'cart': jsonEncode(cart),
      'profilePicPath': profilePicPath,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      favorites: List<int>.from(jsonDecode(map['favorites'] ?? '[]')),
      cart: List<int>.from(jsonDecode(map['cart'] ?? '[]')),
      profilePicPath: map['profilePicPath'],
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, '
        'password: [hidden], favorites: $favorites, cart: $cart, '
        'profilePicPath: $profilePicPath}';
  }
}

class UserTable {
  final DatabaseManager _dbManager;
  final String _tableName = 'users';

  UserTable(this._dbManager);

  Future<int> insertUser(User user) async {
    try {
      final db = await _dbManager.database;
      return await db.insert(
        _tableName,
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,  // Abort on UNIQUE violation to catch errors
      );
    } on DatabaseException catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        print('Duplicate email attempted: ${user.email}');
        return -2;  // Signal duplicate email
      }
      print('Error inserting user: $e');
      return -1;
    } catch (e) {
      print('Error inserting user: $e');
      return -1;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final db = await _dbManager.database;
      final List<Map<String, dynamic>> maps = await db.query(_tableName);
      return List.generate(maps.length, (i) => User.fromMap(maps[i]));
    } catch (e) {
      print('Error retrieving users: $e');
      return [];
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await _dbManager.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'email = ?',
        whereArgs: [email],  // Safe parameterization
      );
      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error retrieving user by email: $e');
      return null;
    }
  }

  Future<User?> getUserByName(String name) async {
    try {
      final db = await _dbManager.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'name = ?',
        whereArgs: [name],  // Safe parameterization
      );
      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error retrieving user by name: $e');
      return null;
    }
  }

  Future<int> updateUser(User user) async {
    try {
      final db = await _dbManager.database;
      return await db.update(
        _tableName,
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],  // Safe parameterization
      );
    } catch (e) {
      print('Error updating user: $e');
      return -1;
    }
  }

  Future<int> deleteUser(int id) async {
    try {
      final db = await _dbManager.database;
      return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting user: $e');
      return -1;
    }
  }
}