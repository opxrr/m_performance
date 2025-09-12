import 'package:sqflite/sqflite.dart';

import 'database_manager.dart';
import 'part.dart';

class CarParts {
  final int carId;
  final int partId;

  CarParts({required this.carId, required this.partId});

  Map<String, dynamic> toMap() {
    return {'carId': carId, 'partId': partId};
  }

  factory CarParts.fromMap(Map<String, dynamic> map) {
    return CarParts(carId: map['carId'], partId: map['partId']);
  }

  @override
  String toString() {
    return 'CarParts{carId: $carId, partId: $partId}';
  }
}

class CarPartsTable {
  final DatabaseManager _dbManager;
  final String _tableName = 'car_parts';

  CarPartsTable(this._dbManager);

  Future<int> insertCarParts(CarParts carParts) async {
    try {
      final db = await _dbManager.database;
      return await db.insert(
        _tableName,
        carParts.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting car_parts: $e');
      return -1;
    }
  }

  Future<List<Part>> getCompatibleParts(int carId) async {
    try {
      final db = await _dbManager.database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        '''
        SELECT p.* FROM parts p
        INNER JOIN $_tableName cp ON p.id = cp.partId
        WHERE cp.carId = ?
      ''',
        [carId],
      );
      return List.generate(maps.length, (i) => Part.fromMap(maps[i]));
    } catch (e) {
      print('Error retrieving compatible parts: $e');
      return [];
    }
  }

  Future<int> deleteCarParts(int carId, int partId) async {
    try {
      final db = await _dbManager.database;
      return await db.delete(
        _tableName,
        where: 'carId = ? AND partId = ?',
        whereArgs: [carId, partId],
      );
    } catch (e) {
      print('Error deleting car_parts: $e');
      return -1;
    }
  }
}
