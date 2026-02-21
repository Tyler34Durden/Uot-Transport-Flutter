//added the code after i removed it
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:uot_transport/auth_feature/model/repository/student_auth_repository.dart';
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
import 'package:uot_transport/auth_feature/model/repository/change_season_repository.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/change_season_cubit.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport_flutter/core/app_bloc.dart';
import 'package:uot_transport_flutter/core/locator.dart';

import 'auth_feature/view/screens/splash_screen.dart';

// تعريف مفتاح ScaffoldMessenger
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<bool> _tryInitializeFirebase() async {
  try {
    await Firebase.initializeApp();
    return true;
  } catch (e) {
    debugPrint(
        'Firebase.initializeApp failed (continuing without Firebase): $e');
    return false;
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {
    return;
  }
  // Handle background message
  print('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator(); // Initialize DI
  final firebaseInitialized = await _tryInitializeFirebase();

  // Force system UI overlays (no immersive), and set nav bar color to match app bar to avoid overlap/transparent issues.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.primaryColor,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  if (firebaseInitialized) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // تهيئة خدمة الإشعارات وتمرير مفتاح Navigator
  // final notificationService = NotificationService();
  // await notificationService.init(scaffoldMessengerKey);

  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings iosInitSettings =
      DarwinInitializationSettings();
  final InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
    iOS: iosInitSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // Android notification channel setup
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'channel_id',
    'channel_name',
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(
    MultiRepositoryProvider(
      providers: [
        // You can remove these if you want to use get_it for repositories as well
        // RepositoryProvider<StudentAuthRepository>(
        //   create: (context) => studentRepository,
        // ),
        // ...other RepositoryProviders...
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<StudentAuthCubit>()),
          BlocProvider(create: (context) => getIt<HomeStationCubit>()),
          BlocProvider(create: (context) => getIt<AdvertisingsCubit>()),
          BlocProvider(create: (context) => getIt<StationTripsCubit>()),
          BlocProvider(create: (context) => getIt<TripsCubit>()),
          BlocProvider(create: (context) => getIt<StationsCubit>()..fetchStations()),
          BlocProvider(create: (context) => getIt<ProfileCubit>()),
          BlocProvider(create: (context) => getIt<ChangeSeasonCubit>()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize NotificationService after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService().init(
        scaffoldMessengerKey,
        navigatorKey.currentContext!,
        navigatorKey,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AppBloc>(),
      child: MaterialApp(
        scaffoldMessengerKey:
            scaffoldMessengerKey, // تمرير المفتاح هنا حتى يتمكن ScaffoldMessenger من عرض الـ SnackBar
        navigatorKey: navigatorKey, // تمرير navigatorKey هنا
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Almarai',
        ),
        home: const SplashScreen(),
        //dd
      ),
    );
  }
}
