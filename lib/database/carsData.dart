import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CarProject {
  final int? id;
  final String imagePath;
  final String modelName;
  final int price;
  final String description;

  CarProject({
    this.id,
    required this.imagePath,
    required this.modelName,
    required this.price,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'modelName': modelName,
      'price': price,
      'description': description,
    };
  }

  factory CarProject.fromMap(Map<String, dynamic> map) {
    return CarProject(
      id: map['id'],
      imagePath: map['imagePath'],
      modelName: map['modelName'],
      price: map['price'],
      description: map['description'],
    );
  }

  @override
  String toString() {
    return 'CarProject{id: $id, imagePath: $imagePath,'
        ' modelName: $modelName, price: $price, description: $description}';
  }
}

class CarsTable {
  Database? _database;
  String _tableName = 'cars';
  String _databaseName = 'cars.db';

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
              modelName TEXT NOT NULL,
              imagePath TEXT NOT NULL,
              price INTEGER NOT NULL,
              description TEXT NOT NULL
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

  Future<int> insertCar(CarProject car) async {
    try {
      final db = await database;
      return await db.insert(
        _tableName,
        car.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting car: $e');
      return -1;
    }
  }

  Future<List<CarProject>> getAllCars() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(_tableName);
      return List.generate(maps.length, (i) => CarProject.fromMap(maps[i]));
    } catch (e) {
      print('Error retrieving cars: $e');
      return [];
    }
  }

  Future<CarProject?> getCarByModel(String model) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'modelName = ?',
        whereArgs: [model],
      );
      if (maps.isNotEmpty) {
        return CarProject.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error retrieving car by model: $e');
      return null;
    }
  }

  Future<int> updateCar(CarProject car) async {
    try {
      final db = await database;
      return await db.update(
        _tableName,
        car.toMap(),
        where: 'id = ?',
        whereArgs: [car.id],
      );
    } catch (e) {
      print('Error updating Car: $e');
      return -1;
    }
  }

  Future<int> deleteCar(int id) async {
    try {
      final db = await database;
      return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting car: $e');
      return -1; // Indicate failure
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
