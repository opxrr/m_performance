import 'package:m_performance/m_database/models/product.dart';

class Car implements Product {
  @override
  final int? id;
  @override
  final String modelName;
  @override
  final String imagePath;
  @override
  final int price;
  @override
  final String description;
  final int horsepower;
  final int topSpeed;
  final int weight;
  final double zeroToHundred;

  Car({
    this.id,
    required this.modelName,
    required this.imagePath,
    required this.price,
    required this.description,
    required this.horsepower,
    required this.topSpeed,
    required this.weight,
    required this.zeroToHundred,
  });

  @override
  String get name => modelName;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'modelName': modelName,
      'imagePath': imagePath,
      'price': price,
      'description': description,
      'horsepower': horsepower,
      'topSpeed': topSpeed,
      'weight': weight,
      'zeroToHundred': zeroToHundred,
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'],
      modelName: map['modelName'],
      imagePath: map['imagePath'],
      price: map['price'],
      description: map['description'],
      horsepower: map['horsepower'],
      topSpeed: map['topSpeed'],
      weight: map['weight'],
      zeroToHundred: map['zeroToHundred'],
    );
  }

  @override
  String toString() {
    return 'Car{id: $id, modelName: $modelName, imagePath: $imagePath, '
        'price: $price, description: $description, horsepower: $horsepower, '
        'topSpeed: $topSpeed, weight: $weight, zeroToHundred: $zeroToHundred}';
  }
}
