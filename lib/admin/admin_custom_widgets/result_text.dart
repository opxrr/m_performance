import 'package:flutter/material.dart';

class ResultText extends StatelessWidget {
  final String result;
  final Color color;

  const ResultText({Key? key, required this.result, this.color = Colors.white})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        result,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
