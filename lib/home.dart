import 'package:flutter/material.dart';

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
    return Scaffold(
        appBar: AppBar(title: Text("Easyperiod")),
        backgroundColor: Colors.white,
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
                        "EasyPerod",
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
