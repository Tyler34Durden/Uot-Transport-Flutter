//added after removed
import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/widgets/home_header.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HomeHeader(
            onMenuPressed: () {
              // Handle menu press
            },
          ),
          // يمكنك إضافة المزيد من الويدجت هنا
        ],
      ),
    );
  }
}