import 'package:flutter/material.dart';
import 'home.dart';
import 'register.dart';
import 'login.dart';
import 'resetpassword.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pages/addperiod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        '/addperiod': (context) => Addperiod(),
      },
    );
  }
}
