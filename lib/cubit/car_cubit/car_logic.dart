import 'package:bloc/bloc.dart';
import 'package:m_performance/m_database/models/car.dart';
import 'package:m_performance/m_database/models/part.dart';

import 'car_state.dart';

class CarLogic extends Cubit<CarState> {
  CarLogic() : super(InitCar());

  void showCar(Car car) {
    emit(ShowCar(car: car, originalCar: car));
  }

  void applyPartUpgrade(Car originalCar, Part part) {
    final currentState = state;
    List<Part> updatedParts = [];
    bool isPartApplied = false;

    if (currentState is ShowCar) {
      isPartApplied = currentState.appliedParts.any((p) => p.id == part.id);
      updatedParts = List.from(currentState.appliedParts);
    } else if (currentState is UpdateCar) {
      isPartApplied = currentState.appliedParts.any((p) => p.id == part.id);
      updatedParts = List.from(currentState.appliedParts);
    }

    if (isPartApplied) {
      updatedParts.removeWhere((p) => p.id == part.id);
    } else {
      updatedParts.add(part);
    }

    int totalHpBoost = updatedParts.fold(0, (sum, p) => sum + p.hpBoost);
    int totalTopSpeedBoost = updatedParts.fold(
      0,
      (sum, p) => sum + p.topSpeedBoost,
    );
    int totalWeightChange = updatedParts.fold(
      0,
      (sum, p) => sum + p.weightChange,
    );
    double totalZeroToHundredChange = updatedParts.fold(
      0.0,
      (sum, p) => sum + p.zeroToHundredChange,
    );

    final updatedCar = Car(
      id: originalCar.id,
      modelName: originalCar.modelName,
      price: originalCar.price,
      imagePath: originalCar.imagePath,
      description: originalCar.description,
      horsepower: originalCar.horsepower + totalHpBoost,
      topSpeed: originalCar.topSpeed + totalTopSpeedBoost,
      weight: originalCar.weight + totalWeightChange,
      zeroToHundred: originalCar.zeroToHundred + totalZeroToHundredChange,
    );

    emit(
      UpdateCar(
        car: updatedCar,
        appliedParts: updatedParts,
        originalCar: originalCar,
      ),
    );
  }
}
