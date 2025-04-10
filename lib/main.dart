
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:uot_transport/auth_feature/view/screens/onboarding_screen.dart';
// import 'package:uot_transport/auth_feature/view_model/cubit/student_cubit.dart';
// import 'package:uot_transport/auth_feature/model/repository/student_repository.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final studentRepository = StudentRepository();
//   runApp(
//     BlocProvider(
//       create: (context) => StudentCubit(studentRepository),
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Almarai',
//       ),
//       home: OnBoardingScreen(),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/auth_feature/view/screens/onboarding_screen.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_cubit.dart';
import 'package:uot_transport/auth_feature/model/repository/student_repository.dart';
import 'package:uot_transport/station_feature/model/repository/stations_repository.dart';
import 'package:uot_transport/station_feature/view_model/cubit/stations_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final studentRepository = StudentRepository();
  final stationsRepository = StationsRepository();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => studentRepository),
        RepositoryProvider(create: (context) => stationsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => StudentCubit(studentRepository),
          ),
          BlocProvider(
            create: (context) => StationsCubit(stationsRepository),
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