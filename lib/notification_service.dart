// import 'package:firebase_messaging/firebase_messaging.dart';

// class NotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> init() async {
//     // طلب إذن الإشعارات (ضروري لبعض الأنظمة)
//     NotificationSettings settings = await _firebaseMessaging.requestPermission();
//     print('User granted permission: ${settings.authorizationStatus}');

//     // استرجاع التوكن واختباره
//     String? token = await _firebaseMessaging.getToken();
//     print('Firebase Messaging Token: $token');

//     // استقبال الرسائل عند وجود الرسائل في الواجهة النشطة
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Received a message in foreground: ${message.notification?.body}');
//     });

//     // استقبال الأحداث عند النقر على إشعار في حالة فتح التطبيق
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('Notification clicked!');
//     });

//     // تسجيل معالج الرسائل في الخلفية
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }
// }

// // هذه الدالة يجب أن تكون دالة من المستوى الأعلى لمعالجة الرسائل في الخلفية
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Handling a background message: ${message.messageId}');
// }


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init(GlobalKey<ScaffoldMessengerState> messengerKey) async {
    // طلب إذن الإشعارات (ضروري لبعض الأنظمة)
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    print('User granted permission: ${settings.authorizationStatus}');

    // استرجاع التوكن واختباره
    String? token = await _firebaseMessaging.getToken();
    print('Firebase Messaging Token: $token');

    // استقبال الرسائل عندما يكون التطبيق في الواجهة النشطة
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notificationBody = message.notification?.body ?? 'No message body';
      print('Received a message in foreground: $notificationBody');
      // عرض الإشعار على شكل SnackBar داخل التطبيق
      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(notificationBody),
          duration: const Duration(seconds: 3),
        ),
      );
    });

    // استقبال الأحداث عند النقر على إشعار في حالة فتح التطبيق
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked!');
      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(message.notification?.body ?? 'Notification clicked!'),
          duration: const Duration(seconds: 3),
        ),
      );
    });

    // تسجيل معالج الرسائل في الخلفية
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

// هذه الدالة يجب أن تكون دالة من المستوى الأعلى لمعالجة الرسائل في الخلفية
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}