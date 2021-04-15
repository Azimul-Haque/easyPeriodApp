import 'package:flutter/material.dart';
import 'package:easyperiod/globals.dart';

class Calendar extends StatefulWidget {
  Calendar({Key key}) : super(key: key);
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
          appBar: commonAppBar('Calendar', this.context),
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
                          "Calendar",
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
