import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TestingLottie extends StatelessWidget {
  const TestingLottie({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Lottie.asset(
          'assets/images/Comp 1 (1).json',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}