import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'car.dart';
import 'database_manager.dart';

class CarManager {
  final DatabaseManager _dbManager = DatabaseManager();
  final TextEditingController idController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController imagePathController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController horsepowerController = TextEditingController();
  final TextEditingController topSpeedController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController zeroToHundredController = TextEditingController();

  Future<String> insertCar() async {
    try {
      if (modelController.text.isEmpty ||
          imagePathController.text.isEmpty ||
          priceController.text.isEmpty ||
          descriptionController.text.isEmpty ||
          horsepowerController.text.isEmpty ||
          topSpeedController.text.isEmpty ||
          weightController.text.isEmpty ||
          zeroToHundredController.text.isEmpty) {
        return 'All fields are required';
      }
      final price = int.tryParse(priceController.text);
      final horsepower = int.tryParse(horsepowerController.text);
      final topSpeed = int.tryParse(topSpeedController.text);
      final weight = int.tryParse(weightController.text);
      final zeroToHundred = double.tryParse(zeroToHundredController.text);
      if (price == null || price <= 0) {
        return 'Please enter a valid positive price';
      }
      if (horsepower == null || horsepower <= 0) {
        return 'Please enter a valid positive horsepower';
      }
      if (topSpeed == null || topSpeed <= 0) {
        return 'Please enter a valid positive top speed';
      }
      if (weight == null || weight <= 0) {
        return 'Please enter a valid positive weight';
      }
      if (zeroToHundred == null || zeroToHundred <= 0) {
        return 'Please enter a valid positive 0-100 time';
      }
      Car car = Car(
        modelName: modelController.text,
        imagePath: imagePathController.text,
        price: price,
        description: descriptionController.text,
        horsepower: horsepower,
        topSpeed: topSpeed,
        weight: weight,
        zeroToHundred: zeroToHundred,
      );
      final db = await _dbManager.database;
      int res = await db.insert(
        'cars', // Table name from DatabaseManager
        car.toMap(),
        conflictAlgorithm:
            ConflictAlgorithm.replace, // Handles potential conflicts
      );
      return res > 0 ? 'Car added successfully: $res' : 'Inserting failed!';
    } catch (e) {
      return 'Error adding car: $e';
    }
  }

  Future<String> updateCar() async {
    try {
      if (idController.text.isEmpty ||
          int.tryParse(idController.text) == null) {
        return 'Car not found';
      }
      final price = int.tryParse(priceController.text);
      final horsepower = int.tryParse(horsepowerController.text);
      final topSpeed = int.tryParse(topSpeedController.text);
      final weight = int.tryParse(weightController.text);
      final zeroToHundred = double.tryParse(zeroToHundredController.text);
      if (price == null || price <= 0) {
        return 'Please enter a valid positive price';
      }
      if (horsepower == null || horsepower <= 0) {
        return 'Please enter a valid positive horsepower';
      }
      if (topSpeed == null || topSpeed <= 0) {
        return 'Please enter a valid positive top speed';
      }
      if (weight == null || weight <= 0) {
        return 'Please enter a valid positive weight';
      }
      if (zeroToHundred == null || zeroToHundred <= 0) {
        return 'Please enter a valid positive 0-100 time';
      }
      Car car = Car(
        id: int.parse(idController.text),
        modelName: modelController.text,
        imagePath: imagePathController.text,
        price: price,
        description: descriptionController.text,
        horsepower: horsepower,
        topSpeed: topSpeed,
        weight: weight,
        zeroToHundred: zeroToHundred,
      );
      final db = await _dbManager.database;
      int res = await db.update(
        'cars',
        car.toMap(),
        where: 'id = ?',
        whereArgs: [car.id],
      );
      return res > 0 ? 'Car updated!' : 'Update failed';
    } catch (e) {
      return 'Error updating car: $e';
    }
  }

  Future<String> deleteCar() async {
    try {
      if (idController.text.isEmpty ||
          int.tryParse(idController.text) == null) {
        return 'Car not found';
      }
      final db = await _dbManager.database;
      int res = await db.delete(
        'cars',
        where: 'id = ?',
        whereArgs: [int.parse(idController.text)],
      );
      return res > 0 ? 'Car deleted successfully' : 'Deleting failed';
    } catch (e) {
      return 'Error deleting car: $e';
    }
  }

  Future<List<Car>> getAllCars() async {
    try {
      final db = await _dbManager.database;
      final List<Map<String, dynamic>> maps = await db.query('cars');
      return List.generate(maps.length, (i) => Car.fromMap(maps[i]));
    } catch (e) {
      throw Exception('Error retrieving cars: $e');
    }
  }

  Future<Car?> getCarByModel(String model) async {
    try {
      final db = await _dbManager.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'cars',
        where: 'modelName = ?',
        whereArgs: [model],
      );
      if (maps.isNotEmpty) {
        return Car.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Error searching car: $e');
    }
  }

  void dispose() {
    idController.dispose();
    modelController.dispose();
    imagePathController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    horsepowerController.dispose();
    topSpeedController.dispose();
    weightController.dispose();
    zeroToHundredController.dispose();
  }
}
