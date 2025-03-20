
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/auth_feature/view/screens/onboarding_screen.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_cubit.dart';
import 'package:uot_transport/auth_feature/model/repository/student_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final studentRepository = StudentRepository();
  runApp(
    BlocProvider(
      create: (context) => StudentCubit(studentRepository),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Almarai',
      ),
      home: OnBoardingScreen(),
    );
  }
}