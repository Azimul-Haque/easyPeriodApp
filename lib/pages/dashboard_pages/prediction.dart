import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyperiod/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class Prediction extends StatefulWidget {
  final data;
  Prediction(this.data);
  @override
  _PredictionState createState() => _PredictionState(this.data);
}

class _PredictionState extends State<Prediction> {
  var data;
  _PredictionState(this.data);
  User userdata;
  var nextprobableperiod;
  List startdatelist = [];

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
    fetchPeriodStartDays();
  }

  @override
  Widget build(BuildContext context) {
    // var screenwidth = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: AppBar(
        title: Text('Prediction'),
        flexibleSpace: appBarStyle(),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(CupertinoIcons.multiply),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        "Period prediction",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                elevation: 2,
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      nextprobableperiod != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  CupertinoIcons.drop_fill,
                                  color: Colors.red,
                                  size: 15,
                                ),
                                Text(
                                  "Next probable period: " + nextprobableperiod,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          : CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
              Text(
                "N.B.: Calculated from your period data.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/faded/8.png"),
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

  fetchPeriodStartDays() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('periods');

    collectionReference
        .where('uid', isEqualTo: userdata.uid)
        .orderBy('start', descending: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        snapshot.docs.forEach((doc) {
          startdatelist.add(doc.get("start"));
        });
        // 2 tar beshi data hoile avg korbe
        if (startdatelist.length > 2) {
          var cumulateddays = 0;
          double avgdays = 0;
          for (var i = 1; i < startdatelist.length; i++) {
            cumulateddays = cumulateddays +
                differenceOfDates(DateTime.parse(startdatelist[i - 1]),
                    DateTime.parse(startdatelist[i]));
            // print(differenceOfDates(DateTime.parse(startdatelist[i - 1]),
            //     DateTime.parse(startdatelist[i])));
          }
          avgdays = cumulateddays / (startdatelist.length - 1);
          // print('Avg: ' + avgdays.toInt().toString());
          nextprobableperiod = DateFormat("MMMM dd, yyyy").format(DateTime(
              DateTime.parse(startdatelist[0]).year,
              DateTime.parse(startdatelist[0]).month,
              DateTime.parse(startdatelist[0]).day + avgdays.toInt()));
        } else {
          nextprobableperiod = DateFormat("MMMM dd, yyyy").format(DateTime(
              DateTime.parse(startdatelist[0]).year,
              DateTime.parse(startdatelist[0]).month,
              DateTime.parse(startdatelist[0]).day + 28));
        }
      });
    });
  }

  differenceOfDates(date1, date2) {
    var dayscount = date1.difference(date2).inDays; //  + 1
    return dayscount;
  }
}
