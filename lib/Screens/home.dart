import 'package:flutter/material.dart';
import 'package:m_performance/m_database/car.dart';
import 'package:m_performance/m_database/car_manager.dart';

import '../custom_widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'homeScreen';

  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> swiperImages = [
    'assets/images/m3.jpeg',
    'assets/images/m5.jpeg',
  ];

  final PageController _pageController = PageController();

  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < swiperImages.length - 1) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _currentPage--;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

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
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
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
                      onPressed: _prevPage,
                      icon: const Icon(
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
                      onPressed: _nextPage,
                      icon: const Icon(
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
                        FutureBuilder<List<Car>>(
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
                              children: cars.map((product) {
                                return MyProductCard(product: product);
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


/*
import 'package:flutter/material.dart';
import 'package:m_performance/admin/car_manager.dart';
import 'package:m_performance/database/carsData.dart';
import '../custom_widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'homeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarManager carManager = CarManager();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> swiperImages = [
    'assets/images/m3.jpeg',
    'assets/images/m5.jpeg',
  ];

  void _nextPage() {
    if (_currentPage < swiperImages.length - 1) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _currentPage--;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/profiles_pictures/pic1.jpeg'),
          ),
          title: const Text(
            " Welcome Back 👋 ",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            " Ali Ahmed ",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.person, color: Colors.white, size: 28),
              SizedBox(width: 13),
              Icon(Icons.settings, color: Colors.white, size: 28),
            ],
          ),
        ),
      ),

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
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
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
                      onPressed: _prevPage,
                      icon: const Icon(
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
                      onPressed: _nextPage,
                      icon: const Icon(
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

          // Cars list
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
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
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
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
                                  style: TextStyle(color: Colors.white70, fontSize: 16),
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
* */
