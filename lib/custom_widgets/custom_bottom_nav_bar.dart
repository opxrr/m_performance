import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      style: TabStyle.react,
      backgroundColor: const Color(0xFF121212),
      color: Colors.white,
      activeColor: const Color(0xFF0066B1),
      initialActiveIndex: currentIndex,
      curveSize: 100,
      height: 55,
      items: const [
        TabItem(icon: Icons.directions_car, title: 'Home'),
        TabItem(icon: Icons.travel_explore, title: 'Explore'),
        TabItem(icon: Icons.person, title: 'Profile'),
      ],
      onTap: onTabSelected,
    );
  }
}
