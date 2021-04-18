import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User userdata;

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
          // appBar: commonAppBar('Dashboard', this.context),
          body: SafeArea(
        child: Container(
            padding: EdgeInsets.only(top: 20, left: 25, bottom: 5, right: 25),
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Container(
                    child: Column(
                  children: <Widget>[
                    Text(
                      "User: " + userdata.displayName,
                      style: TextStyle(
                          color: Colors.red.shade900,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
              ],
            ))),
      )),
    );
  }
}
