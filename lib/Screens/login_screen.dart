import 'package:flutter/material.dart';
import 'package:m_performance/Screens/home.dart';
import 'package:m_performance/Screens/register_screen.dart';
import 'package:m_performance/admin/admin_panel.dart';
import 'package:m_performance/custom_widgets/custom_text_form_field.dart';
import 'package:m_performance/m_database/database_manager.dart';
import 'package:m_performance/m_database/models/user.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'loginScreen';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseManager _dbManager = DatabaseManager();
  final UserTable _userTable = UserTable(DatabaseManager());
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please enter email and password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _userTable.getUserByEmail(email);
      if (user != null && user.password == password) {
        if (mounted) {
          final route = (email == 'admin@email.com')
              ? AdminPanel.routeName
              : HomeScreen.routeName;
          Navigator.pushReplacementNamed(context, route, arguments: user);
        }
      } else {
        _showSnackBar('Invalid email or password');
      }
    } catch (e) {
      _showSnackBar('An error occurred: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF232020),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: Image.asset(
          "assets/images/mLogo.png",
          width: 160,
          errorBuilder: (context, error, stackTrace) =>
          const Text('Logo', style: TextStyle(color: Colors.white)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 100),
            const Text(
              "Welcome Back 👋",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Sign in to continue",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              preIcon: const Icon(
                Icons.email_outlined,
                color: Colors.white70,
              ),
              hintText: 'email',
              obscureText: false,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'email is required';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'enter a valid email';
                }
                return null;
              },
            ),
            CustomTextFormField(
              preIcon: const Icon(
                Icons.password_outlined,
                color: Colors.white70,
              ),
              hintText: 'password',
              obscureText: true,
              controller: _passwordController,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'password is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20), // Matches CustomTextFormField padding
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 6,
                ),
                onPressed: _isLoading ? null : _signIn,
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => Navigator.pushNamed(
                context,
                RegisterScreen.routeName,
              ),
              child: const Text(
                "Don't have an account? Sign Up",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}