import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easyperiod/globals.dart';

class Periodlist extends StatefulWidget {
  Periodlist({Key key}) : super(key: key);
  @override
  _PeriodlistState createState() => _PeriodlistState();
}

class _PeriodlistState extends State<Periodlist> {
  User userdata;
  List periods;
  var periodstext = 'loading...';

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
    this.fetchPeriods();
    print(periods);
    setState(() {
      periodstext = periods.first.toString();
    });
  }

  fetchPeriods() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('periods');

    collectionReference.snapshots().listen((snapshot) {
      setState(() {
        periods = snapshot.docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
          appBar: commonAppBar('Periodlist', this.context),
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
                          periodstext,
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
