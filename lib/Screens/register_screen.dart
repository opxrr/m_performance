import 'package:flutter/material.dart';
import 'package:m_performance/custom_widgets/custom_text_form_field.dart';
import 'package:m_performance/m_database/database_manager.dart';
import 'package:m_performance/m_database/models/user.dart';
import 'package:sqflite/sqflite.dart';


class RegisterScreen extends StatefulWidget {
  static const String routeName = 'registerScreen';

  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserTable _userTable = UserTable(DatabaseManager());

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      User newUser = User(
        name: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        favorites: [],
        cart: [],
        profilePicPath: null,
      );
      try {
        int id = await _userTable.insertUser(newUser);
        if (id != -1) {
          // Show success dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFF232020),
              title: const Text(
                'Welcome aboard!',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'loginScreen');
                  },
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        } else {
          // Show generic error dialog
          _showErrorDialog('Error registering user. Please try again.');
        }
      } on DatabaseException catch (e) {
        if (e.isUniqueConstraintError()) {
          _showErrorDialog('Email already exists. Please use a different email.');
        } else {
          _showErrorDialog('Error registering user: $e');
        }
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF232020),
        title: const Text(
          'Registration Failed',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                preIcon: const Icon(
                  Icons.alternate_email,
                  color: Colors.white70,
                ),
                hintText: 'username',
                obscureText: false,
                controller: _usernameController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'username is required';
                  }
                  return null;
                },
              ),
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
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
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
                  if (value.length < 6) {
                    return 'password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Register', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}