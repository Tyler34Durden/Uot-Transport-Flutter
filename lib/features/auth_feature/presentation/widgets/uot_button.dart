import 'package:flutter/material.dart';

class UotButton extends StatelessWidget {
  const UotButton({
    super.key,
    required this.color,
    required this.textColor,
    required this.text,
    required this.ontap,
  });

  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(color),
        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
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
