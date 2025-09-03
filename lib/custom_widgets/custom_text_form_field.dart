import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final Icon preIcon;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool autofocus;

  const CustomTextFormField({
    super.key,
    required this.preIcon,
    required this.hintText,
    required this.obscureText,
    this.controller,
    this.validator,
    this.keyboardType,
    this.autofocus = false,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        autofocus: widget.autofocus,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: widget.preIcon,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF232020),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  onPressed: _toggleObscureText,
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
