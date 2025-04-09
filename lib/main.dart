
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/auth_feature/view/screens/onboarding_screen.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_cubit.dart';
import 'package:uot_transport/auth_feature/model/repository/student_auth_repository.dart';
import 'package:uot_transport/home_feature/model/repository/home_repository.dart';
import 'package:uot_transport/home_feature/view_model/cubit/advertising_cubit.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final studentRepository = StudentAuthRepository();
  final homeRepository = HomeRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StudentAuthCubit(studentRepository),
        ),
        BlocProvider(
          create: (context) => AdvertisingsCubit(HomeRepository())..fetchAdvertisings(),
        ),
        BlocProvider(
          create: (context) => TripsCubit(homeRepository)..fetchTodayTrips(),
        ),
      ],
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