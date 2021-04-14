import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'globals.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var name;
  var email;
  var password;
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        appBar: AppBar(
          title: Text("EasyPeriod"),
          automaticallyImplyLeading: false,
          flexibleSpace: appBarStyle(),
          actions: <Widget>[
            PopupMenuButton(
              offset: Offset(0, 30),
              onSelected: (value) async {
                switch (value) {
                  case 'signout':
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, '/');
                    break;
                  case 'rate':
                    if (await canLaunch("https://orbachinujbuk.com")) {
                      await launch(
                          "https://play.google.com/store/apps/details?id=com.madladsInc.boi_mela");
                    } else {
                      throw 'Could not launch!';
                    }
                    break;
                  default:
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: "signout",
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.logout,
                          color: Colors.black87,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Sign Out")
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: "rate",
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.black87,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Rate Us")
                      ],
                    ),
                  ),
                ];
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
