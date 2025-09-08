import 'package:flutter/material.dart';
import 'package:m_performance/database/carsData.dart';

class CarManager {
  final CarsTable _carsTable = CarsTable();
  final TextEditingController idController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController imagePathController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<String> insertCar() async {
    try {
      if (modelController.text.isEmpty ||
          imagePathController.text.isEmpty ||
          priceController.text.isEmpty ||
          descriptionController.text.isEmpty) {
        return 'All fields are required';
      }
      final price = int.tryParse(priceController.text);
      if (price == null || price <= 0) {
        return 'Please enter a valid positive price';
      }
      CarProject car = CarProject(
        modelName: modelController.text,
        imagePath: imagePathController.text,
        price: price,
        description: descriptionController.text,
      );
      int res = await _carsTable.insertCar(car);
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
      if (price == null || price <= 0) {
        return 'Please enter a valid positive price';
      }
      CarProject car = CarProject(
        id: int.parse(idController.text),
        modelName: modelController.text,
        imagePath: imagePathController.text,
        price: price,
        description: descriptionController.text,
      );
      int res = await _carsTable.updateCar(car);
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
      int res = await _carsTable.deleteCar(int.parse(idController.text));
      return res > 0 ? 'Car deleted successfully' : 'Deleting failed';
    } catch (e) {
      return 'Error deleting car: $e';
    }
  }

  Future<List<CarProject>> getAllCars() async {
    try {
      return await _carsTable.getAllCars();
    } catch (e) {
      throw Exception('Error retrieving cars: $e');
    }
  }

  Future<CarProject?> getCarByModel(String model) async {
    try {
      return await _carsTable.getCarByModel(model);
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
    _carsTable.close();
  }
}
