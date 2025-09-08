import 'package:flutter/material.dart';
import 'package:m_performance/admin/car_manager.dart';
import 'package:m_performance/database/carsData.dart';

import '../custom_widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'homeScreen';
  final List<String> swiperImages = [
    'assets/images/m3.jpeg',
    'assets/images/m5.jpeg',
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CarManager carManager = CarManager();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Swiper
          SizedBox(
            height: 250,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: PageView(
                    children: swiperImages.map((path) {
                      return Image.asset(path, fit: BoxFit.cover);
                    }).toList(),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_left,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "M Performance — crafted for speed lovers.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        FutureBuilder<List<CarProject>>(
                          future: carManager.getAllCars(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Error loading cars: ${snapshot.error}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              );
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No cars available',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }
                            final cars = snapshot.data!;
                            return GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children: cars.map((car) {
                                return ProductCard(car: car);
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
