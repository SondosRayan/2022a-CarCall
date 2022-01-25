import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../globals.dart';
import 'navigation_bar.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  '206601031', // id
  'High Importance Notifications', // title// description
  importance: Importance.max,
  showBadge: true,
);

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();



  static Future<void> initilize() async {
    print("***************************************** initialize ");
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    await _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) {
          print(payload);
          print("notification screen");

          Navigator.push(navigatorKey.currentContext!,
              MaterialPageRoute(builder: (context) =>  MyNavigationBar(index: int.parse(payload!))));
        });
  }

  static Future<void> showNotificationOnForeground(RemoteMessage message) async {
    print("***************************************** showNotificationOnForeground");
    try {
      final notificationDetail = NotificationDetails(
          android: AndroidNotificationDetails(
              "206601031",
              "206601031",
              importance: Importance.max,
              priority: Priority.high,
              visibility: NotificationVisibility.public,
              ledOffMs: 10,
              ledOnMs: 10,
              playSound: true,
              color: green11,
              largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
              fullScreenIntent: true,
              ledColor: green2));

      String GoTo = "";

      if(message.notification!.title == "Alert" || message.notification!.title == "Help Offer"){
        GoTo = "3";
      }
      else{
        GoTo = "1";
      }

      await _notificationsPlugin.show(
          DateTime
              .now()
              .microsecond,
          message.notification!.title,
          message.notification!.body,
          notificationDetail,
          payload: GoTo);

    }
    catch(e){
      print("ERROR in showNotificationOnForeground ");
      print(e);
    }
  }
}