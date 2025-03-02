import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/screens/home_screen.dart';
import 'package:uot_transport/auth_feature/view/screens/login_screen.dart';
import 'package:uot_transport/auth_feature/view/screens/onboarding_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     theme: ThemeData(

        fontFamily: 'Almarai',
      ),
      home:  const Home(),
    );
  }
}


