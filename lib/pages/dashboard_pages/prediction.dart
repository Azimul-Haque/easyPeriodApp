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

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;

    nextprobableperiod = DateFormat("MMMM dd, yyyy")
        .format(DateTime(data.year, data.month, data.day + 28));
    print(nextprobableperiod);
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
          padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
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
              Card(
                elevation: 2,
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
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
                      ),
                    ],
                  ),
                ),
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
}
