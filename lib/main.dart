import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:uot_transport/core/splash_screen.dart';

// تعريف مفتاح ScaffoldMessenger
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<bool> _tryInitializeFirebase() async {
  try {
    // Firebase is initialized in main().
    return true;
  } catch (e) {
    debugPrint('Firebase initialize check failed (continuing without Firebase): $e');
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

  final prefs = await SharedPreferences.getInstance();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCSGIJeWX719AG2uXrABx6R4LPsvRspw2g",
        authDomain: "uot-transport.firebaseapp.com",
        databaseURL: "https://uot-transport-default-rtdb.europe-west1.firebasedatabase.app",
        projectId: "uot-transport",
        storageBucket: "uot-transport.firebasestorage.app",
        messagingSenderId: "940757879830",
        appId: "1:940757879830:web:6be003dc34edac627cf937",
        measurementId: "G-6BH868DGH5",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  setupLocator(prefs: prefs); // Initialize DI

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

  // Remove MultiBlocProvider and BlocProvider for cubits
  runApp(
    MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorKey: navigatorKey,
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Almarai',
      ),
      home: const SplashScreen(),
    ),
  );
}
