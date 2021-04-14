import 'package:flutter/material.dart';
import 'package:easyperiod/globals.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
          appBar: commonAppBar('Profile', this.context),
          body: SafeArea(
            child: Container(
                padding:
                    EdgeInsets.only(top: 20, left: 25, bottom: 5, right: 25),
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    Container(
                        child: Column(
                      children: <Widget>[
                        Text(
                          "Period List",
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
