// @dart=2.9

import 'package:car_call/screens/LocalNotificationService.dart';
import 'package:car_call/screens/login_signup_screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:provider/provider.dart';
import 'auth_repository.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';

Future<void> backroundHandler(RemoteMessage message) async {
  print(" This is message from background");
  print(message.notification.title);
  print(message.notification.body);
  LocalNotificationService.initilize();
  LocalNotificationService.showNotificationOnForeground(message);
}

Future<void> SetChannel() async {
  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'Your channel description',
    id: '206601031',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'myChannel',
    visibility: NotificationVisibility.VISIBILITY_PUBLIC,
    allowBubbles: true,
    enableVibration: true,
    enableSound: true,
    showBadge: true,

  );
  print(result);
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  LocalNotificationService.initilize();

  //await SetChannel();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text(snapshot.error.toString(),
                      textDirection: TextDirection.ltr)));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthRepository>(
      create: (_) => AuthRepository.instance(),
      child: Consumer<AuthRepository>(
        builder: (context, _login, _) =>
            const MaterialApp(
              home: LoginScreen(),
            ),
      ),
    );

  }
}
/*
return const MaterialApp(
      home: LoginScreen(),
    );
 */