import 'package:flutter/material.dart';
import 'package:m_performance/database/carsData.dart';

class CarsHome extends StatelessWidget {
  const CarsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Cars Home'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          CarsTable carsTable = CarsTable();
          carsTable.createCarsTable();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
