import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final int? id;
  final String username;
  final String email;
  final String password;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    String? gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, email: $email, password: $password}';
  }
}

class UsersTable {
  Database? _database;
  static const String _tableName = 'users';
  static const String _databaseName = 'users.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), _databaseName);
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $_tableName (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT NOT NULL,
              email TEXT NOT NULL UNIQUE,
              password TEXT NOT NULL
            )
          ''');
          print('Table $_tableName created');
        },
        onOpen: (db) {
          print('Database opened!');
        },
      );
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future<int> insertUser(User user) async {
    try {
      final db = await database;
      return await db.insert(
        _tableName,
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting user: $e');
      return -1;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(_tableName);
      return List.generate(maps.length, (i) => User.fromMap(maps[i]));
    } catch (e) {
      print('Error retrieving users: $e');
      return [];
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'email = ?',
        whereArgs: [email],
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

  Future<int> updateUser(User user) async {
    try {
      final db = await database;
      return await db.update(
        _tableName,
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } catch (e) {
      print('Error updating user: $e');
      return -1;
    }
  }

  Future<int> deleteUser(int id) async {
    try {
      final db = await database;
      return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting user: $e');
      return -1; // Indicate failure
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
