import 'package:flutter/material.dart';
        import 'package:lottie/lottie.dart';

        class TestingLottie extends StatelessWidget {
          const TestingLottie({super.key});

          @override
          Widget build(BuildContext context) {
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/images/splashScreen.json',
                    width: 600,
                    height: 600,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 5,),
                  Lottie.asset(
                    'assets/images/Comp 1 (1).json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            );
          }
        }