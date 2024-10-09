import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPermissionService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotification() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static InitializationSettings initializationSettings =
      const InitializationSettings(
    iOS: DarwinInitializationSettings(),
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );

  sendSimpleNotification(String id) {
    flutterLocalNotificationsPlugin.show(
      1,
      'Order Completed',
      'Your order id :$id has been completed please collect from the counter',
      notificationDetails,
    );
  }

  static NotificationDetails notificationDetails = const NotificationDetails(
    android: AndroidNotificationDetails(
      'dine',
      'dine',
      priority: Priority.high,
      importance: Importance.max,
    ),
    iOS: DarwinNotificationDetails(),
  );
}
