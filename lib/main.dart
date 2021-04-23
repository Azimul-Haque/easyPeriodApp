import 'package:easyperiod/pages/calendar.dart';
import 'package:easyperiod/pages/dashboard.dart';
import 'package:easyperiod/pages/periodlist.dart';
import 'package:easyperiod/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'home.dart';
import 'pages/addperiod.dart';
import 'register.dart';
import 'login.dart';
import 'package:easyperiod/pages/dashboard_pages/prediction.dart';
import 'package:easyperiod/pages/dashboard_pages/graph.dart';
import 'package:easyperiod/pages/dashboard_pages/insights.dart';
import 'package:easyperiod/pages/profile_pages/myaccount.dart';
import 'package:easyperiod/pages/profile_pages/changepass.dart';
import 'package:easyperiod/pages/profile_pages/notifications.dart';
import 'package:easyperiod/pages/profile_pages/feedback.dart';
import 'package:easyperiod/pages/profile_pages/settings.dart';

import 'resetpassword.dart';
import 'package:firebase_core/firebase_core.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid =
      AndroidInitializationSettings('ic_stat_onesignal_default');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyPeriod',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/resetpassword': (context) => ResetPasswordPage(),
        '/homepage': (context) => HomePage(),
        '/dashboard': (context) => Dashboard(),
        '/periodlist': (context) => Periodlist(),
        '/calendar': (context) => Calendar(),
        '/profile': (context) => Profile(),
        '/addperiod': (context) => Addperiod(),
        '/myaccount': (context) => MyAccount(),
        '/changepass': (context) => ChangePass(),
        '/notifications': (context) => Notifications(),
        '/feedback': (context) => FeedBack(),
        '/settings': (context) => Settings(),
        // '/prediction': (context) => Prediction(context),
        '/graph': (context) => Graph(),
        '/insights': (context) => Insights(),
      },
    );
  }
}
