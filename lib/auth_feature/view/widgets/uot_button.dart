import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';

class UotButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback ontap;

  const UotButton({
    super.key,
    required this.color,
    required this.textColor,
    required this.text,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: ontap,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}