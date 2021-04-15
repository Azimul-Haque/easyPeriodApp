import 'package:easyperiod/globals.dart';
import 'package:flutter/material.dart';

class Addperiod extends StatefulWidget {
  @override
  _AddperiodState createState() => _AddperiodState();
}

class _AddperiodState extends State<Addperiod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: appBarStyle(),
          title: Text('Add Period'),
        ),
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
                        "Add Period",
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
        ));
  }
}
