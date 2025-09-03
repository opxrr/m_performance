import 'package:sqflite/sqflite.dart';

class CarsTable {
  late Database carsData;

  createCarsTable() async {
    carsData = await openDatabase(
      'cars.db',
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE cars (imagePath TEXT, id INTEGER PRIMARY KEY,"
          "modelName TEXT, price INTEGER )",
        );
        print('Table Cars created');
      },
      onOpen: (db) {
        print('Database Opened !');
      },
    );
  }

  insertCar({
    required String imagePath,
    required int id,
    required String modelName,
    required int price,
  }) {}
}
