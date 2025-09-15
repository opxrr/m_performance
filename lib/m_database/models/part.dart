import 'package:m_performance/m_database/models/product.dart';

class Part implements Product {
  @override
  final int? id;
  final String partName;
  @override
  final String imagePath;
  @override
  final int price;
  @override
  final String description;
  final int hpBoost;
  final int topSpeedBoost;
  final int weightChange;
  final double zeroToHundredChange;

  Part({
    this.id,
    required this.partName,
    required this.imagePath,
    required this.price,
    required this.description,
    required this.hpBoost,
    required this.topSpeedBoost,
    required this.weightChange,
    required this.zeroToHundredChange,
  });

  @override
  String get name => partName;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'partName': partName,
      'imagePath': imagePath,
      'price': price,
      'description': description,
      'hpBoost': hpBoost,
      'topSpeedBoost': topSpeedBoost,
      'weightChange': weightChange,
      'zeroToHundredChange': zeroToHundredChange,
    };
  }

  factory Part.fromMap(Map<String, dynamic> map) {
    return Part(
      id: map['id'],
      partName: map['partName'],
      imagePath: map['imagePath'],
      price: map['price'],
      description: map['description'],
      hpBoost: map['hpBoost'],
      topSpeedBoost: map['topSpeedBoost'],
      weightChange: map['weightChange'],
      zeroToHundredChange: map['zeroToHundredChange'],
    );
  }

  @override
  String toString() {
    return 'Part{id: $id, partName: $partName, imagePath: $imagePath, '
        'price: $price, description: $description, hpBoost: $hpBoost, '
        'topSpeedBoost: $topSpeedBoost, weightChange: $weightChange, '
        'zeroToHundredChange: $zeroToHundredChange}';
  }
}
