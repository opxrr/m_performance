// lib/admin/admin_custom_widgets/search_button.dart
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:m_performance/admin/admin_custom_widgets/dialogs.dart';
import 'package:m_performance/admin/admin_custom_widgets/search_type.dart';
import 'package:m_performance/m_database/car_manager.dart';
import 'package:m_performance/m_database/part_manager.dart';
import 'package:m_performance/m_database/user.dart';

// Remove this local definition:
// enum SearchType { car, part, user }

class SearchButton extends StatelessWidget {
  final CarManager carManager;
  final PartManager partManager;
  final UserTable userTable;
  final TextEditingController searchController;
  final Function(String result, ContentType type) onResult;
  final BuildContext parentContext;
  final SearchType searchType;

  const SearchButton({
    Key? key,
    required this.carManager,
    required this.partManager,
    required this.userTable,
    required this.searchController,
    required this.onResult,
    required this.parentContext,
    required this.searchType,
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
          if (searchType == SearchType.car) {
            final car = await carManager.getCarByModel(searchController.text);
            if (car != null) {
              Dialogs.showCarDetailsDialog(parentContext, car);
              onResult('Car found!', ContentType.success);
            } else {
              onResult('Car not found!', ContentType.warning);
            }
          } else if (searchType == SearchType.part) {
            final part = await partManager.getPartByName(searchController.text);
            if (part != null) {
              Dialogs.showPartDetailsDialog(parentContext, part);
              onResult('Part found!', ContentType.success);
            } else {
              onResult('Part not found!', ContentType.warning);
            }
          } else if (searchType == SearchType.user) {
            final user = await userTable.getUserByName(searchController.text);
            if (user != null) {
              Dialogs.showUserDetailsDialog(parentContext, user);
              onResult('User found!', ContentType.success);
            } else {
              onResult('User not found!', ContentType.warning);
            }
          }
        } catch (e) {
          onResult('Error searching: $e', ContentType.failure);
        }
      },
      child: const Text('Search', style: TextStyle(color: Colors.white)),
    );
  }
}