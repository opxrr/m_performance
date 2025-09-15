import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  Database? _database;
  final String _databaseName = 'm_performance.db';
  final String _usersTable = 'users';
  final String _carsTable = 'cars';
  final String _partsTable = 'parts';
  final String _cartItemsTable = 'cart_items';
  final String _carPartsTable = 'car_parts';

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
        version: 2,
        onCreate: (db, version) async {
          print('onCreate triggered - Creating fresh DB');
          // Create Users table
          await db.execute('''
            CREATE TABLE $_usersTable (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              email TEXT NOT NULL UNIQUE,
              password TEXT NOT NULL,
              favorites TEXT NOT NULL DEFAULT '[]',
              cart TEXT NOT NULL DEFAULT '[]',
              profilePicPath TEXT
            )
          ''');


          await db.insert(
            _usersTable,
            {
              'name': 'Admin',
              'email': 'admin@email.com',
              'password': 'adminpass',
              'favorites': '[]',
              'cart': '[]',
            },
            conflictAlgorithm: ConflictAlgorithm.abort,
          );
          print('Admin user inserted successfully (onCreate)');

          await db.execute('''
            CREATE TABLE $_carsTable (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              modelName TEXT NOT NULL,
              imagePath TEXT NOT NULL,
              price INTEGER NOT NULL,
              description TEXT NOT NULL,
              horsepower INTEGER NOT NULL,
              topSpeed INTEGER NOT NULL,
              weight INTEGER NOT NULL,
              zeroToHundred REAL NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE $_partsTable (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              partName TEXT NOT NULL,
              imagePath TEXT NOT NULL,
              price INTEGER NOT NULL,
              description TEXT NOT NULL,
              hpBoost INTEGER NOT NULL,
              topSpeedBoost INTEGER NOT NULL,
              weightChange INTEGER NOT NULL,
              zeroToHundredChange REAL NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE $_cartItemsTable (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              userId INTEGER NOT NULL,
              productId INTEGER NOT NULL,
              productType TEXT NOT NULL,
              quantity INTEGER NOT NULL,
              FOREIGN KEY (userId) REFERENCES $_usersTable(id) ON DELETE CASCADE
            )
          ''');

          await db.execute('''
            CREATE TABLE $_carPartsTable (
              carId INTEGER NOT NULL,
              partId INTEGER NOT NULL,
              PRIMARY KEY (carId, partId),
              FOREIGN KEY (carId) REFERENCES $_carsTable(id) ON DELETE CASCADE,
              FOREIGN KEY (partId) REFERENCES $_partsTable(id) ON DELETE CASCADE
            )
          ''');

          print('Database and tables created (onCreate)');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          print('Database upgrade from version $oldVersion to $newVersion');
          if (oldVersion < 2) {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS $_usersTable (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                email TEXT NOT NULL UNIQUE,
                password TEXT NOT NULL,
                favorites TEXT NOT NULL DEFAULT '[]',
                cart TEXT NOT NULL DEFAULT '[]',
                profilePicPath TEXT
              )
            ''');

            // Check if admin exists; insert if not
            final adminExists = Sqflite.firstIntValue(
              await db.rawQuery('SELECT id FROM $_usersTable WHERE email = ?', ['admin@email.com']),
            );
            if (adminExists == null) {
              await db.insert(
                _usersTable,
                {
                  'name': 'Admin',
                  'email': 'admin@email.com',
                  'password': 'adminpass',
                  'favorites': '[]',
                  'cart': '[]',
                },
                conflictAlgorithm: ConflictAlgorithm.abort,
              );
              print('Admin user inserted successfully (onUpgrade)');
            } else {
              print('Admin user already exists (onUpgrade)');
            }

            await db.execute('''
              CREATE TABLE IF NOT EXISTS $_carsTable (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                modelName TEXT NOT NULL,
                imagePath TEXT NOT NULL,
                price INTEGER NOT NULL,
                description TEXT NOT NULL,
                horsepower INTEGER NOT NULL,
                topSpeed INTEGER NOT NULL,
                weight INTEGER NOT NULL,
                zeroToHundred REAL NOT NULL
              )
            ''');

            await db.execute('''
              CREATE TABLE IF NOT EXISTS $_partsTable (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                partName TEXT NOT NULL,
                imagePath TEXT NOT NULL,
                price INTEGER NOT NULL,
                description TEXT NOT NULL,
                hpBoost INTEGER NOT NULL,
                topSpeedBoost INTEGER NOT NULL,
                weightChange INTEGER NOT NULL,
                zeroToHundredChange REAL NOT NULL
              )
            ''');

            await db.execute('''
              CREATE TABLE IF NOT EXISTS $_cartItemsTable (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                userId INTEGER NOT NULL,
                productId INTEGER NOT NULL,
                productType TEXT NOT NULL,
                quantity INTEGER NOT NULL,
                FOREIGN KEY (userId) REFERENCES $_usersTable(id) ON DELETE CASCADE
              )
            ''');

            await db.execute('''
              CREATE TABLE IF NOT EXISTS $_carPartsTable (
                carId INTEGER NOT NULL,
                partId INTEGER NOT NULL,
                PRIMARY KEY (carId, partId),
                FOREIGN KEY (carId) REFERENCES $_carsTable(id) ON DELETE CASCADE,
                FOREIGN KEY (partId) REFERENCES $_partsTable(id) ON DELETE CASCADE
              )
            ''');

            print('Upgrade completed - Tables ensured and admin checked');
          }
        },
        onOpen: (db) async {
          print('Database opened!');
          print('Current DB version: ${await db.rawQuery("PRAGMA user_version")}');
        },
      );
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}