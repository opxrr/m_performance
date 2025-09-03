import 'package:flutter/material.dart';

import '../custom_widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  final List<String> swiperImages = [
    'assets/images/m3.jpeg',
    'assets/images/m5.jpeg',
  ];
  final List<Map> pCards = [
    {
      'imageUrl': 'assets/images/m1.jpg',
      'productName': 'M1 Speedster',
      'price': 45000,
    },
    {
      'imageUrl': 'assets/images/m2.jpeg',
      'productName': 'M2 Coupe',
      'price': 48000,
    },
    {
      'imageUrl': 'assets/images/m3.jpeg',
      'productName': 'M3 Sedan',
      'price': 52000,
    },
    {
      'imageUrl': 'assets/images/m04.jpg',
      'productName': 'M4 Competition',
      'price': 60000,
    },
    {
      'imageUrl': 'assets/images/m5.jpeg',
      'productName': 'M5 Touring',
      'price': 65000,
    },
    {
      'imageUrl': 'assets/images/m06.jpeg',
      'productName': 'M6 Gran Coupe',
      'price': 70000,
    },
    {
      'imageUrl': 'assets/images/m07.jpg',
      'productName': 'M7 Luxury',
      'price': 75000,
    },
    {
      'imageUrl': 'assets/images/m4LB.jpeg',
      'productName': 'M4L Edition',
      'price': 62000,
    },
    {
      'imageUrl': 'assets/images/m05.jpg',
      'productName': 'M0S Sport',
      'price': 55000,
    },
    {
      'imageUrl': 'assets/images/m05.jpg',
      'productName': 'M05 Classic',
      'price': 50000,
    },
    {
      'imageUrl': 'assets/images/m06.jpeg',
      'productName': 'M06 Performance',
      'price': 58000,
    },
    {
      'imageUrl': 'assets/images/m07.jpg',
      'productName': 'M07 Elite',
      'price': 63000,
    },
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: pCards.map((product) {
                            return ProductCard(
                              imageUrl: product['imageUrl'],
                              productName: product['productName'],
                              price: product['price'].toDouble(),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 800),
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
