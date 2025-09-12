import 'car.dart';
import 'cart_item.dart';
import 'database_manager.dart';
import 'part.dart';

class CarDetailsManager {
  final DatabaseManager _dbManager;
  Car _car;
  List<Part> _compatibleParts = [];
  Part? _selectedPart;
  int _updatedPrice = 0;
  String _updatedDescription = '';
  int _updatedHorsepower = 0;
  int _updatedTopSpeed = 0;
  int _updatedWeight = 0;
  double _updatedZeroToHundred = 0.0;

  CarDetailsManager(this._dbManager, this._car) {
    _updatedPrice = _car.price;
    _updatedDescription = _car.description;
    _updatedHorsepower = _car.horsepower;
    _updatedTopSpeed = _car.topSpeed;
    _updatedWeight = _car.weight;
    _updatedZeroToHundred = _car.zeroToHundred;
  }

  Car get car => _car;

  List<Part> get compatibleParts => _compatibleParts;

  Part? get selectedPart => _selectedPart;

  int get updatedPrice => _updatedPrice;

  String get updatedDescription => _updatedDescription;

  int get updatedHorsepower => _updatedHorsepower;

  int get updatedTopSpeed => _updatedTopSpeed;

  int get updatedWeight => _updatedWeight;

  double get updatedZeroToHundred => _updatedZeroToHundred;

  Future<void> loadCompatibleParts() async {
    try {
      final carPartsTable = CarPartsTable(_dbManager);
      _compatibleParts = await carPartsTable.getCompatibleParts(_car.id!);
    } catch (e) {
      print('Error loading compatible parts: $e');
      _compatibleParts = [];
    }
  }

  void selectPart(Part? part) {
    _selectedPart = part;
    if (part != null) {
      _updatedPrice = _car.price + part.price;
      _updatedDescription = '${_car.description} (with ${part.partName})';
      _updatedHorsepower = _car.horsepower + part.hpBoost;
      _updatedTopSpeed = _car.topSpeed + part.topSpeedBoost;
      _updatedWeight = _car.weight + part.weightChange;
      _updatedZeroToHundred = (_car.zeroToHundred + part.zeroToHundredChange)
          .clamp(0.0, double.infinity);
    } else {
      _updatedPrice = _car.price;
      _updatedDescription = _car.description;
      _updatedHorsepower = _car.horsepower;
      _updatedTopSpeed = _car.topSpeed;
      _updatedWeight = _car.weight;
      _updatedZeroToHundred = _car.zeroToHundred;
    }
  }
}
