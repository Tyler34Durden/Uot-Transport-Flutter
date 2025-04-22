import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/auth_feature/view/screens/onboarding_screen.dart';
import 'package:uot_transport/auth_feature/model/repository/student_auth_repository.dart';
import 'package:uot_transport/auth_feature/view/screens/splash_screen.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_cubit.dart';
import 'package:uot_transport/home_feature/model/repository/home_repository.dart';
import 'package:uot_transport/home_feature/view_model/cubit/advertising_cubit.dart';
import 'package:uot_transport/station_feature/model/repository/stations_repository.dart';
import 'package:uot_transport/station_feature/view_model/cubit/stations_cubit.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_cubit.dart';
import 'package:uot_transport/profile_feature/model/repository/profile_repository.dart';
import 'package:uot_transport/profile_feature/view_model/cubit/profile_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final studentRepository = StudentAuthRepository();
  final homeRepository = HomeRepository();
  final stationsRepository = StationsRepository();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<StudentAuthRepository>(
          create: (context) => studentRepository,
        ),
        RepositoryProvider<HomeRepository>(
          create: (context) => homeRepository,
        ),
        RepositoryProvider<StationsRepository>(
          create: (context) => stationsRepository,
        ),
     
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => StudentAuthCubit(studentRepository),
          ),
          BlocProvider(
            create: (context) =>
                AdvertisingsCubit(homeRepository)..fetchAdvertisings(),
          ),
          BlocProvider(
            create: (context) =>
                TripsCubit(homeRepository)..fetchTodayTrips(),
          ),
          BlocProvider(
            create: (context) => TripsCubit(homeRepository),
          ),
          BlocProvider(
            create: (context) => StationsCubit(stationsRepository)
              ..fetchStations(),
          ),
          
        ],
        child: const MyApp(),
      ),
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