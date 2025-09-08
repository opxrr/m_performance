import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;
  final Icon? prefixIcon;

  const CustomDropdownButton({
    super.key,
    required this.hintText,
    required this.items,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.prefixIcon,
  });

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedValue,
        hint: Text(
          widget.hintText,
          style: const TextStyle(color: Colors.white70),
        ),
        items: widget.items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedValue = newValue;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(newValue);
          }
        },
        validator: widget.validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
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
        ),
        dropdownColor: const Color(0xFF232020),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
      ),
    );
  }
}
