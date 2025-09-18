import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_performance/Screens/explore.dart';
import 'package:m_performance/Screens/home.dart';
import 'package:m_performance/Screens/login_screen.dart';
import 'package:m_performance/Screens/product_details_screen.dart';
import 'package:m_performance/Screens/profile.dart';
import 'package:m_performance/Screens/register_screen.dart';
import 'package:m_performance/admin/admin_panel.dart';
import 'package:m_performance/cubit/car_cubit/car_logic.dart';
import 'package:m_performance/m_database/models/product.dart';
import 'package:m_performance/main_layout.dart';
import 'package:m_performance/theme/app_themes.dart';

import 'm_database/models/car.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CarLogic(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'M Performance Tuning',
        theme: ThemeData(
          primaryColor: Color(0xFF0066B1),
          secondaryHeaderColor: Color(0x323547FF),

          scaffoldBackgroundColor: Colors.grey.shade100,
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            headlineMedium: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          cardColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.indigo),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
          dividerColor: Colors.grey,
        ),
        home: const MainLayout(),
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          ExploreScreen.routeName: (context) => ExploreScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
          RegisterScreen.routeName: (context) => const RegisterScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          AdminPanel.routeName: (context) => const AdminPanel(),
          ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(
            product:
                ModalRoute.of(context)!.settings.arguments as Product? ??
                Car(
                  id: 0,
                  modelName: 'Unknown',
                  price: 0,
                  imagePath: 'assets/images/placeholder.jpeg',
                  description: 'No description available',
                  horsepower: 0,
                  topSpeed: 0,
                  weight: 0,
                  zeroToHundred: 0,
                ),
          ),
        },
      ),
    );
  }
}
