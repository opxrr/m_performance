import 'package:flutter/material.dart';
import 'package:m_performance/custom_widgets/special_offer_widget.dart';

class SearchScreen extends StatelessWidget {
  List<Map> offers = [
    {
      'pName': 'E36 M3 V8',
      'imagePath': 'assets/images/E36-V8-P63.jpg',
      'price': 48000,
      'oldPrice': 52000.0,
    },
    {
      'pName': 'M4 Competition',
      'imagePath': 'assets/images/mRims.jpg',
      'price': 60000,
      'oldPrice': 65000.0,
    },
    {
      'pName': 'E36 M3 V8',
      'imagePath': 'assets/images/E36-V8-P63.jpg',
      'price': 48000,
      'oldPrice': 52000.0,
    },
    {
      'pName': 'M4 Competition',
      'imagePath': 'assets/images/mRims.jpg',
      'price': 60000,
      'oldPrice': 65000.0,
    },
  ];

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SearchBar(
              hintStyle: WidgetStatePropertyAll(TextStyle(color: Colors.grey)),
              hintText: 'Search...',
              leading: Icon(Icons.search, color: Colors.blue),
            ),
          ),
          Center(
            child: Text(
              'Special Deals !',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: offers.map((offer) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SpecialOfferWidget(
                    imagePath: offer['imagePath'],
                    pName: offer['pName'],
                    price: offer['price'].toDouble(),
                    oldPrice: offer['oldPrice'].toDouble(),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
