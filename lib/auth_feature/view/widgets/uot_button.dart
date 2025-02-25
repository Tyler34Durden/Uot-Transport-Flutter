import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';
class UotButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  const UotButton({super.key, required this.color, required this.textColor, required this.text,});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text( text,
      style: TextStyle(color: color),
      ),
    );
  }
}
