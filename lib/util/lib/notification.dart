// import 'dart:io';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationUtil {
//   /*
//     # Sample format
//
//     {
//         "notification": {
//             "title": "Title goes here...",
//             "body": "Body goes here..."
//         },
//         "data": {
//             "title": "Title goes here...",
//             "body": "Body goes here...",
//             "click_action": "FLUTTER_NOTIFICATION_CLICK",
//             "is_background": "true",
//             "content_available": "true"
//         }
//     }
//   */
//
//   FlutterLocalNotificationsPlugin? _plugin;
//
//   NotificationUtil._internal();
//
//   static final NotificationUtil _instance = NotificationUtil._internal();
//
//   static NotificationUtil on() {
//     return _instance;
//   }
//
//   void configLocalNotification(
//     SelectNotificationCallback onSelectCallback,
//   ) async {
//     if (_plugin == null) {
//       _plugin = FlutterLocalNotificationsPlugin();
//     }
//
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       description: 'This channel is used for important notifications.', // description
//       importance: Importance.max,
//     );
//
//     await _plugin
//         ?.resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     var initializationSettings = InitializationSettings(
//       android: AndroidInitializationSettings('app_icon'),
//       iOS: IOSInitializationSettings(),
//     );
//
//     _plugin?.initialize(
//       initializationSettings,
//       onSelectNotification: onSelectCallback,
//     );
//   }
//
//   void showNotification(RemoteMessage message) async {
//     if (Platform.isAndroid &&
//         message.notification != null &&
//         message.notification?.title != null &&
//         message.notification?.body != null &&
//         message.notification!.title!.isNotEmpty &&
//         message.notification!.body!.isNotEmpty) {
//       var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//         'default_channel_id',
//         'Default',
//         channelDescription: 'default description',
//         playSound: true,
//         enableVibration: true,
//         importance: Importance.max,
//         priority: Priority.max,
//       );
//
//       var iOSPlatformChannelSpecifics = IOSNotificationDetails(
//         presentAlert: true,
//         presentSound: true,
//       );
//
//       var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics,
//       );
//
//       await _plugin?.show(
//         message.hashCode,
//         message.notification?.title,
//         message.notification?.body,
//         platformChannelSpecifics,
//       );
//     }
//   }
// }
