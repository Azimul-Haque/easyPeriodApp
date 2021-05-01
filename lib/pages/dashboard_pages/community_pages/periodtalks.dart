import 'package:easyperiod/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PeriodTalks extends StatefulWidget {
  PeriodTalks({Key key}) : super(key: key);
  @override
  _PeriodTalksState createState() => _PeriodTalksState();
}

class _PeriodTalksState extends State<PeriodTalks> {
  User userdata;

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    // var screenwidth = MediaQuery.of(context).size.width;
    return new Scaffold(
      body: GestureDetector(
        child: Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
          child: Column(
            children: <Widget>[
              Text("Period talk Coming soon..."),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await canLaunch(
                      "https://play.google.com/store/apps/details?id=com.orbachinujbuk.easyperiod")) {
                    await launch(
                        "https://play.google.com/store/apps/details?id=com.orbachinujbuk.easyperiod");
                  } else {
                    throw 'Could not launch!';
                  }
                },
                child: Text("Check for updates"),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/faded/10.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
