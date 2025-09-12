import 'package:flutter/material.dart';
import 'package:m_performance/Screens/product_details_screen.dart';
import 'package:m_performance/Screens/login_screen.dart';
import 'package:m_performance/Screens/register_screen.dart';
import 'package:m_performance/admin/admin_panel.dart';
import 'package:m_performance/main_layout.dart';

import 'Screens/explore.dart';
import 'Screens/home.dart';
import 'Screens/profile.dart';
import 'm_database/product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'M Performance Tuning',
      home: MainLayout(),
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        ExploreScreen.routeName: (context) => ExploreScreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        AdminPanel.routeName: (context) => AdminPanel(),
        ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(
          product: ModalRoute.of(context)!.settings.arguments as Product,
        ),
      },
    );
  }
}
