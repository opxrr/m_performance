import 'package:flutter/material.dart';
import 'package:m_performance/m_database/car.dart';
import 'package:m_performance/m_database/part.dart';
import 'package:m_performance/m_database/user.dart';
import 'package:m_performance/m_database/car_manager.dart';
import 'package:m_performance/m_database/part_manager.dart';

class Dialogs {
  static void showAddCarDialog({
    required BuildContext context,
    required CarManager carManager,
    required Function(bool, String) onResult,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        final modelController = TextEditingController();
        final imagePathController = TextEditingController();
        final priceController = TextEditingController();
        final descriptionController = TextEditingController();
        final horsepowerController = TextEditingController();
        final topSpeedController = TextEditingController();
        final weightController = TextEditingController();
        final zeroToHundredController = TextEditingController();
        final formKey = GlobalKey<FormState>();

        return AlertDialog(
          backgroundColor: const Color(0xFF232020),
          title: const Text('Add Car', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: modelController,
                    decoration: const InputDecoration(
                      labelText: 'Model Name',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: imagePathController,
                    decoration: const InputDecoration(
                      labelText: 'Image Path',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: horsepowerController,
                    decoration: const InputDecoration(
                      labelText: 'Horsepower',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                  TextFormField(
                    controller: topSpeedController,
                    decoration: const InputDecoration(
                      labelText: 'Top Speed (km/h)',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                  TextFormField(
                    controller: weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                  TextFormField(
                    controller: zeroToHundredController,
                    decoration: const InputDecoration(
                      labelText: '0-100 km/h (seconds)',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || double.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  carManager.modelController.text = modelController.text;
                  carManager.imagePathController.text = imagePathController.text;
                  carManager.priceController.text = priceController.text;
                  carManager.descriptionController.text = descriptionController.text;
                  carManager.horsepowerController.text = horsepowerController.text;
                  carManager.topSpeedController.text = topSpeedController.text;
                  carManager.weightController.text = weightController.text;
                  carManager.zeroToHundredController.text = zeroToHundredController.text;
                  final result = await carManager.insertCar();
                  Navigator.pop(context);
                  onResult(result.contains('successfully'), result);
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  static void showUpdateCarDialog({
    required BuildContext context,
    required CarManager carManager,
    Car? car,
    required Function() onSuccess,
  }) {
    final modelController = TextEditingController(text: car?.modelName);
    final imagePathController = TextEditingController(text: car?.imagePath);
    final priceController = TextEditingController(text: car?.price.toString());
    final descriptionController = TextEditingController(text: car?.description);
    final horsepowerController = TextEditingController(text: car?.horsepower.toString());
    final topSpeedController = TextEditingController(text: car?.topSpeed.toString());
    final weightController = TextEditingController(text: car?.weight.toString());
    final zeroToHundredController = TextEditingController(text: car?.zeroToHundred.toString());
    final idController = TextEditingController(text: car?.id.toString());
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF232020),
          title: const Text('Update Car', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: idController,
                    decoration: const InputDecoration(
                      labelText: 'Car ID',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    readOnly: true,
                  ),
                  TextFormField(
                    controller: modelController,
                    decoration: const InputDecoration(
                      labelText: 'Model Name',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: imagePathController,
                    decoration: const InputDecoration(
                      labelText: 'Image Path',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: horsepowerController,
                    decoration: const InputDecoration(
                      labelText: 'Horsepower',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                  TextFormField(
                    controller: topSpeedController,
                    decoration: const InputDecoration(
                      labelText: 'Top Speed (km/h)',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                  TextFormField(
                    controller: weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                  TextFormField(
                    controller: zeroToHundredController,
                    decoration: const InputDecoration(
                      labelText: '0-100 km/h (seconds)',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || double.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  carManager.idController.text = idController.text;
                  carManager.modelController.text = modelController.text;
                  carManager.imagePathController.text = imagePathController.text;
                  carManager.priceController.text = priceController.text;
                  carManager.descriptionController.text = descriptionController.text;
                  carManager.horsepowerController.text = horsepowerController.text;
                  carManager.topSpeedController.text = topSpeedController.text;
                  carManager.weightController.text = weightController.text;
                  carManager.zeroToHundredController.text = zeroToHundredController.text;
                  final result = await carManager.updateCar();
                  Navigator.pop(context);
                  if (result.contains('updated')) {
                    onSuccess();
                  }
                }
              },
              child: const Text('Update', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  static void showDeleteCarDialog({
    required BuildContext context,
    required CarManager carManager,
    required Function() onSuccess,
  }) {
    final idController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF232020),
          title: const Text('Delete Car', style: TextStyle(color: Colors.white)),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'Car ID',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid ID' : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  carManager.idController.text = idController.text;
                  final result = await carManager.deleteCar();
                  Navigator.pop(context);
                  if (result.contains('successfully')) {
                    onSuccess();
                  }
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  static void showAddPartDialog({
    required BuildContext context,
    required PartManager partManager,
    required Function(bool, String) onResult,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        final partNameController = TextEditingController();
        final imagePathController = TextEditingController();
        final priceController = TextEditingController();
        final descriptionController = TextEditingController();
        final hpBoostController = TextEditingController();
        final topSpeedBoostController = TextEditingController();
        final weightChangeController = TextEditingController();
        final zeroToHundredChangeController = TextEditingController();
        final formKey = GlobalKey<FormState>();

        return AlertDialog(
          backgroundColor: const Color(0xFF232020),
          title: const Text('Add Part', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: partNameController,
                    decoration: const InputDecoration(
                      labelText: 'Part Name',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: imagePathController,
                    decoration: const InputDecoration(
                      labelText: 'Image Path',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: hpBoostController,
                    decoration: const InputDecoration(
                      labelText: 'Horsepower Boost',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                  TextFormField(
                    controller: topSpeedBoostController,
                    decoration: const InputDecoration(
                      labelText: 'Top Speed Boost (km/h)',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                  TextFormField(
                    controller: weightChangeController,
                    decoration: const InputDecoration(
                      labelText: 'Weight Change (kg)',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                  TextFormField(
                    controller: zeroToHundredChangeController,
                    decoration: const InputDecoration(
                      labelText: '0-100 Change (seconds)',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || double.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  partManager.partNameController.text = partNameController.text;
                  partManager.imagePathController.text = imagePathController.text;
                  partManager.priceController.text = priceController.text;
                  partManager.descriptionController.text = descriptionController.text;
                  partManager.hpBoostController.text = hpBoostController.text;
                  partManager.topSpeedBoostController.text = topSpeedBoostController.text;
                  partManager.weightChangeController.text = weightChangeController.text;
                  partManager.zeroToHundredChangeController.text = zeroToHundredChangeController.text;
                  final result = await partManager.insertPart();
                  Navigator.pop(context);
                  onResult(result.contains('successfully'), result);
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  static void showUpdatePartDialog({
    required BuildContext context,
    required PartManager partManager,
    Part? part,
    required Function() onSuccess,
  }) {
    final partNameController = TextEditingController(text: part?.partName);
    final imagePathController = TextEditingController(text: part?.imagePath);
    final priceController = TextEditingController(text: part?.price.toString());
    final descriptionController = TextEditingController(text: part?.description);
    final hpBoostController = TextEditingController(text: part?.hpBoost.toString());
    final topSpeedBoostController = TextEditingController(text: part?.topSpeedBoost.toString());
    final weightChangeController = TextEditingController(text: part?.weightChange.toString());
    final zeroToHundredChangeController = TextEditingController(text: part?.zeroToHundredChange.toString());
    final idController = TextEditingController(text: part?.id.toString());
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF232020),
          title: const Text('Update Part', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: idController,
                    decoration: const InputDecoration(
                      labelText: 'Part ID',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    readOnly: true,
                  ),
                  TextFormField(
                    controller: partNameController,
                    decoration: const InputDecoration(
                      labelText: 'Part Name',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: imagePathController,
                    decoration: const InputDecoration(
                      labelText: 'Image Path',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: hpBoostController,
                    decoration: const InputDecoration(
                      labelText: 'Horsepower Boost',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                  TextFormField(
                    controller: topSpeedBoostController,
                    decoration: const InputDecoration(
                      labelText: 'Top Speed Boost (km/h)',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                  TextFormField(
                    controller: weightChangeController,
                    decoration: const InputDecoration(
                      labelText: 'Weight Change (kg)',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                  TextFormField(
                    controller: zeroToHundredChangeController,
                    decoration: const InputDecoration(
                      labelText: '0-100 Change (seconds)',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || double.tryParse(value) == null ? 'Enter a valid number' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  partManager.idController.text = idController.text;
                  partManager.partNameController.text = partNameController.text;
                  partManager.imagePathController.text = imagePathController.text;
                  partManager.priceController.text = priceController.text;
                  partManager.descriptionController.text = descriptionController.text;
                  partManager.hpBoostController.text = hpBoostController.text;
                  partManager.topSpeedBoostController.text = topSpeedBoostController.text;
                  partManager.weightChangeController.text = weightChangeController.text;
                  partManager.zeroToHundredChangeController.text = zeroToHundredChangeController.text;
                  final result = await partManager.updatePart();
                  Navigator.pop(context);
                  if (result.contains('updated')) {
                    onSuccess();
                  }
                }
              },
              child: const Text('Update', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  static void showDeletePartDialog({
    required BuildContext context,
    required PartManager partManager,
    required Function() onSuccess,
  }) {
    final idController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF232020),
          title: const Text('Delete Part', style: TextStyle(color: Colors.white)),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'Part ID',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid ID' : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  partManager.idController.text = idController.text;
                  final result = await partManager.deletePart();
                  Navigator.pop(context);
                  if (result.contains('successfully')) {
                    onSuccess();
                  }
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  static void showDeleteUserDialog({
    required BuildContext context,
    required UserTable userTable,
    required Function() onSuccess,
  }) {
    final idController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF232020),
          title: const Text('Delete User', style: TextStyle(color: Colors.white)),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'User ID',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Enter a valid ID' : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final result = await userTable.deleteUser(int.parse(idController.text));
                  Navigator.pop(context);
                  if (result > 0) {
                    onSuccess();
                  }
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  static void showCarDetailsDialog(BuildContext context, Car car) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF232020),
          title: Text(car.modelName, style: const TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    car.imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/placeholder.jpeg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text('ID: ${car.id}', style: const TextStyle(color: Colors.white70)),
                Text('Price: ${car.price} USD', style: const TextStyle(color: Colors.white70)),
                Text('Description: ${car.description}', style: const TextStyle(color: Colors.white70)),
                Text('Horsepower: ${car.horsepower} HP', style: const TextStyle(color: Colors.white70)),
                Text('Top Speed: ${car.topSpeed} km/h', style: const TextStyle(color: Colors.white70)),
                Text('Weight: ${car.weight} kg', style: const TextStyle(color: Colors.white70)),
                Text('0-100 km/h: ${car.zeroToHundred.toStringAsFixed(1)} s', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  static void showPartDetailsDialog(BuildContext context, Part part) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF232020),
          title: Text(part.partName, style: const TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    part.imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/placeholder.jpeg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text('ID: ${part.id}', style: const TextStyle(color: Colors.white70)),
                Text('Price: ${part.price} USD', style: const TextStyle(color: Colors.white70)),
                Text('Description: ${part.description}', style: const TextStyle(color: Colors.white70)),
                Text('HP Boost: ${part.hpBoost}', style: const TextStyle(color: Colors.white70)),
                Text('Top Speed Boost: ${part.topSpeedBoost} km/h', style: const TextStyle(color: Colors.white70)),
                Text('Weight Change: ${part.weightChange} kg', style: const TextStyle(color: Colors.white70)),
                Text('0-100 Change: ${part.zeroToHundredChange.toStringAsFixed(1)} s', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  static void showUserDetailsDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF232020),
          title: Text(user.name, style: const TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: user.profilePicPath != null
                      ? Image.asset(
                    user.profilePicPath!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/placeholder.jpeg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Image.asset(
                    'assets/images/placeholder.jpeg',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text('ID: ${user.id}', style: const TextStyle(color: Colors.white70)),
                Text('Email: ${user.email}', style: const TextStyle(color: Colors.white70)),
                Text('Favorites: ${user.favorites.join(", ")}', style: const TextStyle(color: Colors.white70)),
                Text('Cart: ${user.cart.join(", ")}', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }
}