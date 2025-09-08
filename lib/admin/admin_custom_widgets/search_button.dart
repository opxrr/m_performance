import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

import 'car_dialogs.dart';
import '../car_manager.dart';

class SearchButton extends StatelessWidget {
  final CarManager carManager;
  final TextEditingController searchController;
  final Function(String result, ContentType type) onResult;
  final BuildContext parentContext;

  const SearchButton({
    Key? key,
    required this.carManager,
    required this.searchController,
    required this.onResult,
    required this.parentContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () async {
        try {
          final car = await carManager.getCarByModel(searchController.text);
          if (car != null) {
            CarDialogs.showCarDetailsDialog(parentContext, car);
            onResult('Car found!', ContentType.success);
          } else {
            onResult('Car not found!', ContentType.warning);
          }
        } catch (e) {
          onResult('Error searching car: $e', ContentType.failure);
        }
      },
      child: const Text('Search', style: TextStyle(color: Colors.white)),
    );
  }
}
