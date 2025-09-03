import 'package:flutter/material.dart';
import 'package:m_performance/Screens/login_screen.dart';
import 'package:m_performance/Screens/register_screen.dart';

import 'Screens/explore.dart';
import 'Screens/home.dart';
import 'Screens/profile.dart';
import 'main_layout.dart';

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
        'homeScreen': (context) => HomeScreen(),
        'exploreScreen': (context) => ExploreScreen(),
        'profileScreen': (context) => ProfileScreen(),
        'registerScreen': (context) => RegisterScreen(),
        'loginScreen': (context) => LoginScreen(),
      },
    );
  }
}
