import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:m_performance/database/carsData.dart';

import '../car_manager.dart';

class CarDialogs {
  static void _showAwesomeSnackbar(
    BuildContext context,
    String title,
    String message,
    ContentType type,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: type,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showAddCarDialog(
    BuildContext context, {
    required CarManager carManager,
    required Function(bool success, String message) onResult,
  }) {
    carManager.modelController.clear();
    carManager.imagePathController.clear();
    carManager.priceController.clear();
    carManager.descriptionController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new car'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: carManager.modelController,
                decoration: const InputDecoration(labelText: 'Model name'),
              ),
              TextField(
                controller: carManager.imagePathController,
                decoration: const InputDecoration(labelText: 'Image path'),
              ),
              TextField(
                controller: carManager.priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: carManager.descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final result = await carManager.insertCar();
              if (!context.mounted) return;
              final success = result.startsWith('Car added');
              _showAwesomeSnackbar(
                context,
                success ? 'Success' : 'Error',
                result,
                success ? ContentType.success : ContentType.failure,
              );
              Navigator.pop(context);
              onResult(success, result);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  static void showUpdateCarDialog(
    BuildContext context, {
    required CarManager carManager,
    CarProject? car,
    required VoidCallback onSuccess,
  }) {
    if (car != null) {
      carManager.idController.text = car.id.toString();
      carManager.modelController.text = car.modelName;
      carManager.imagePathController.text = car.imagePath;
      carManager.priceController.text = car.price.toString();
      carManager.descriptionController.text = car.description;
    } else {
      carManager.idController.clear();
      carManager.modelController.clear();
      carManager.imagePathController.clear();
      carManager.priceController.clear();
      carManager.descriptionController.clear();
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update car'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: carManager.idController,
                decoration: const InputDecoration(labelText: 'Car ID'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: carManager.modelController,
                decoration: const InputDecoration(labelText: 'Model Name'),
              ),
              TextField(
                controller: carManager.imagePathController,
                decoration: const InputDecoration(labelText: 'Image path'),
              ),
              TextField(
                controller: carManager.priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: carManager.descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final result = await carManager.updateCar();
              if (!context.mounted) return;
              _showAwesomeSnackbar(
                context,
                result.startsWith('Car updated') ? 'Success' : 'Error',
                result,
                result.startsWith('Car updated')
                    ? ContentType.success
                    : ContentType.failure,
              );
              Navigator.pop(context);
              onSuccess();
            },
            child: const Text('Update'),
          ),
          TextButton(
            onPressed: () async {
              final result = await carManager.deleteCar();
              if (!context.mounted) return;
              _showAwesomeSnackbar(
                context,
                result.startsWith('Car deleted') ? 'Success' : 'Error',
                result,
                result.startsWith('Car deleted')
                    ? ContentType.success
                    : ContentType.failure,
              );
              Navigator.pop(context);
              onSuccess();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  static void showDeleteCarDialog(
    BuildContext context, {
    required CarManager carManager,
    required VoidCallback onSuccess,
  }) {
    carManager.idController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Car'),
        content: TextField(
          controller: carManager.idController,
          decoration: const InputDecoration(labelText: 'Car ID'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final result = await carManager.deleteCar();
              if (!context.mounted) return;
              _showAwesomeSnackbar(
                context,
                result.startsWith('Car deleted') ? 'Success' : 'Error',
                result,
                result.startsWith('Car deleted')
                    ? ContentType.success
                    : ContentType.failure,
              );
              Navigator.pop(context);
              onSuccess();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  static void showCarDetailsDialog(BuildContext context, CarProject car) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Car Project details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                car.imagePath,
                height: 100,
                errorBuilder: (context, error, stackTrace) => const Text(
                  'Error loading car image',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 10),
              Text('ID: ${car.id}'),
              Text('Model Name: ${car.modelName}'),
              Text('Price: ${car.price}'),
              Text('Image path: ${car.imagePath}'),
              Text('Car description: ${car.description}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
