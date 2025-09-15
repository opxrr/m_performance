import 'package:equatable/equatable.dart';
import 'package:m_performance/m_database/models/car.dart';
import 'package:m_performance/m_database/models/part.dart';

abstract class CarState extends Equatable {
  const CarState();

  @override
  List<Object?> get props => [];
}

class InitCar extends CarState {}

class CreateCar extends CarState {}

class InsertCar extends CarState {}

class DeleteCar extends CarState {}

class UpdateCar extends CarState {
  final Car car;
  final List<Part> appliedParts;
  final Car originalCar;

  const UpdateCar({
    required this.car,
    required this.originalCar,
    this.appliedParts = const [],
  });

  @override
  List<Object?> get props => [car, appliedParts, originalCar];
}

class ShowCar extends CarState {
  final Car car;
  final List<Part> appliedParts;
  final Car originalCar;

  const ShowCar({
    required this.car,
    required this.originalCar,
    this.appliedParts = const [],
  });

  @override
  List<Object?> get props => [car, appliedParts, originalCar];
}
