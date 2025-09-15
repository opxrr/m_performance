import 'package:flutter/material.dart';
import 'package:m_performance/m_database/database_manager.dart';
import 'package:m_performance/m_database/models/part.dart';
import 'package:sqflite/sql.dart';

class PartManager {
  final TextEditingController idController = TextEditingController();
  final TextEditingController partNameController = TextEditingController();
  final TextEditingController imagePathController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController hpBoostController = TextEditingController();
  final TextEditingController topSpeedBoostController = TextEditingController();
  final TextEditingController weightChangeController = TextEditingController();
  final TextEditingController zeroToHundredChangeController = TextEditingController();
  final PartTable _partTable = PartTable(DatabaseManager());

  void dispose() {
    idController.dispose();
    partNameController.dispose();
    imagePathController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    hpBoostController.dispose();
    topSpeedBoostController.dispose();
    weightChangeController.dispose();
    zeroToHundredChangeController.dispose();
  }

  Future<String> insertPart() async {
    try {
      final part = Part(
        partName: partNameController.text,
        imagePath: imagePathController.text,
        price: int.parse(priceController.text),
        description: descriptionController.text,
        hpBoost: int.parse(hpBoostController.text),
        topSpeedBoost: int.parse(topSpeedBoostController.text),
        weightChange: int.parse(weightChangeController.text),
        zeroToHundredChange: double.parse(zeroToHundredChangeController.text),
      );
      final id = await _partTable.insertPart(part);
      if (id != -1) {
        return 'Part added successfully with ID: $id';
      } else {
        return 'Failed to add part';
      }
    } catch (e) {
      return 'Error adding part: $e';
    }
  }

  Future<String> updatePart() async {
    try {
      final part = Part(
        id: int.parse(idController.text),
        partName: partNameController.text,
        imagePath: imagePathController.text,
        price: int.parse(priceController.text),
        description: descriptionController.text,
        hpBoost: int.parse(hpBoostController.text),
        topSpeedBoost: int.parse(topSpeedBoostController.text),
        weightChange: int.parse(weightChangeController.text),
        zeroToHundredChange: double.parse(zeroToHundredChangeController.text),
      );
      final rowsAffected = await _partTable.updatePart(part);
      if (rowsAffected > 0) {
        return 'Part updated successfully';
      } else {
        return 'Failed to update part';
      }
    } catch (e) {
      return 'Error updating part: $e';
    }
  }

  Future<String> deletePart() async {
    try {
      final id = int.parse(idController.text);
      final rowsAffected = await _partTable.deletePart(id);
      if (rowsAffected > 0) {
        return 'Part deleted successfully';
      } else {
        return 'Failed to delete part';
      }
    } catch (e) {
      return 'Error deleting part: $e';
    }
  }

  Future<List<Part>> getAllParts() async {
    try {
      return await _partTable.getAllParts();
    } catch (e) {
      print('Error retrieving parts: $e');
      return [];
    }
  }

  Future<Part?> getPartByName(String partName) async {
    try {
      return await _partTable.getPartByName(partName);
    } catch (e) {
      print('Error retrieving part by name: $e');
      return null;
    }
  }
}

class PartTable {
  final DatabaseManager _dbManager;
  final String _tableName = 'parts';

  PartTable(this._dbManager);

  Future<int> insertPart(Part part) async {
    try {
      final db = await _dbManager.database;
      return await db.insert(
        _tableName,
        part.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting part: $e');
      return -1;
    }
  }

  Future<List<Part>> getAllParts() async {
    try {
      final db = await _dbManager.database;
      final List<Map<String, dynamic>> maps = await db.query(_tableName);
      return List.generate(maps.length, (i) => Part.fromMap(maps[i]));
    } catch (e) {
      print('Error retrieving parts: $e');
      return [];
    }
  }

  Future<Part?> getPartByName(String partName) async {
    try {
      final db = await _dbManager.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'partName = ?',
        whereArgs: [partName],
      );
      if (maps.isNotEmpty) {
        return Part.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error retrieving part by name: $e');
      return null;
    }
  }

  Future<int> updatePart(Part part) async {
    try {
      final db = await _dbManager.database;
      return await db.update(
        _tableName,
        part.toMap(),
        where: 'id = ?',
        whereArgs: [part.id],
      );
    } catch (e) {
      print('Error updating part: $e');
      return -1;
    }
  }

  Future<int> deletePart(int id) async {
    try {
      final db = await _dbManager.database;
      return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting part: $e');
      return -1;
    }
  }
}