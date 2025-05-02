//added the code after i removed it
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/auth_feature/model/repository/student_auth_repository.dart';
import 'package:uot_transport/auth_feature/view/screens/splash_screen.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_cubit.dart';
import 'package:uot_transport/home_feature/model/repository/home_repository.dart';
import 'package:uot_transport/home_feature/view_model/cubit/advertising_cubit.dart';
import 'package:uot_transport/home_feature/view_model/cubit/home_station_cubit.dart';
import 'package:uot_transport/notification_service.dart';
import 'package:uot_transport/station_feature/model/repository/station_trips_repository.dart';
import 'package:uot_transport/station_feature/model/repository/stations_repository.dart';
import 'package:uot_transport/station_feature/view_model/cubit/station_trips_cubit.dart';
import 'package:uot_transport/station_feature/view_model/cubit/stations_cubit.dart';
import 'package:uot_transport/trips_feature/model/repository/trips_repository.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_cubit.dart';
import 'package:uot_transport/profile_feature/model/repository/profile_repository.dart';
import 'package:uot_transport/profile_feature/view_model/cubit/profile_cubit.dart';

// تعريف مفتاح ScaffoldMessenger
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // تهيئة خدمة الإشعارات وتمرير مفتاح ScaffoldMessenger
  final notificationService = NotificationService();
  await notificationService.init(scaffoldMessengerKey);

  final studentRepository = StudentAuthRepository();
  final homeRepository = HomeRepository();
  final stationsRepository = StationsRepository();
  final profileRepository = ProfileRepository();
  final stationTripsRepository = StationTripsRepository();
  final tripsRepository = TripsRepository(); // Pass ApiService to TripsRepository

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
        RepositoryProvider<ProfileRepository>(
          create: (context) => profileRepository,
        ),
        RepositoryProvider<StationTripsRepository>(
          create: (context) => stationTripsRepository,
        ),
        RepositoryProvider<TripsRepository>(
          create: (context) => tripsRepository, // Provide TripsRepository
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => StudentAuthCubit(studentRepository),
          ),
          BlocProvider(
            create: (context) => HomeStationCubit(homeRepository)..fetchStations()..fetchTodayTrips(),
          ),
          BlocProvider(
            create: (context) => AdvertisingsCubit(homeRepository)..fetchAdvertisings(),
          ),
          BlocProvider(
            create: (context) => StationTripsCubit(stationTripsRepository),
          ),
          BlocProvider(
              create: (context) => TripsCubit(tripsRepository)..fetchTripsByStations()
          ),
          BlocProvider(
            create: (context) => StationsCubit(stationsRepository)..fetchStations(),
          ),
          BlocProvider(
            create: (context) => ProfileCubit(profileRepository),
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
      scaffoldMessengerKey: scaffoldMessengerKey, // تمرير المفتاح هنا حتى يتمكن ScaffoldMessenger من عرض الـ SnackBar
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Almarai',
      ),
      home: const SplashScreen(),
      //dd
    );
  }
}