import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uot_transport/core/main_screen.dart';

Future<void> showResponseDialog(
  BuildContext context, {
  required bool success,
  required String message,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: success
            ? SvgPicture.asset("assets/icons/check.svg")
            : Icon(Icons.error, color: Colors.red, size: 50),
        content: Container(
          width: 800, 
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  if (success) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const MainScreen()),
                    );
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  success ? 'الذهاب إلى الصفحة الرئيسية' : 'إغلاق',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}