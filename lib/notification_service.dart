import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:another_flushbar/flushbar.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init(
      GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
      BuildContext context, // ✅ تم تمريره هنا
      GlobalKey<NavigatorState> navigatorKey, // <-- add this parameter
      ) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    print('User granted permission: ${settings.authorizationStatus}');

    String? token = await _firebaseMessaging.getToken();
    print('Firebase Messaging Token: $token');

    // الاستماع للرسائل عندما يكون التطبيق نشطًا
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notificationBody = message.notification?.body ?? message.data['body'] ?? 'No message body';
      final notificationTitle = message.notification?.title ?? message.data['title'] ?? 'إشعار جديد';

      Flushbar(
        title: notificationTitle,
        message: notificationBody,
        backgroundColor: AppColors.backgroundColor,
        duration: const Duration(seconds: 4),
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(8),
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        titleColor: AppColors.primaryColor,
        messageColor: AppColors.textColor,
      ).show(context);
    });

    // عند النقر على الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notificationBody = message.notification?.body ?? message.data['body'] ?? 'Notification clicked!';
      final notificationTitle = message.notification?.title ?? message.data['title'] ?? 'إشعار جديد';

      Flushbar(
        titleText: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            notificationTitle,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        messageText: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            notificationBody,
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 14,
            ),
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        duration: const Duration(seconds: 4),
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.zero,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        boxShadows: [
          BoxShadow(
            color: Colors.blue,
            offset: Offset(0, 4), // Position at the bottom
            blurRadius: 0,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.blue,
            offset: Offset(0, 4),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ).show(navigatorKey.currentContext!);
    });
  }
}
