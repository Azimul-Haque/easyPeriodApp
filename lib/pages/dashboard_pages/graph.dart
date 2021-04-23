import 'package:easyperiod/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Graph extends StatefulWidget {
  Graph({Key key}) : super(key: key);
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
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
      appBar: AppBar(
        title: Text('Graph'),
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
                      padding: EdgeInsets.only(
                          top: 0, left: 0, bottom: 10, right: 0),
                      child: Text(
                        "Avg Period Graph",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        // height: 250,
                        // margin: EdgeInsets.only(
                        //     top: 5, left: 15, bottom: 10, right: 15),
                        decoration: new BoxDecoration(
                          color: Colors.indigo[900],
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage("assets/images/faded/2.png"),
                            alignment: Alignment.center,
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 140,
                              padding: EdgeInsets.all(7),
                              child: BarChart(
                                BarChartData(
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border(
                                      left: BorderSide.none,
                                      bottom: BorderSide(
                                        color: Colors.white60,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    leftTitles: SideTitles(showTitles: false),
                                    topTitles: SideTitles(
                                      showTitles: true,
                                      margin: 0,
                                      getTextStyles: (value) =>
                                          getTextforTiles(value),
                                    ),
                                    bottomTitles: SideTitles(
                                      showTitles: false,
                                    ),
                                  ),
                                  // alignment: BarChartAlignment.center,
                                  barGroups: [
                                    barData(28),
                                    barData(27),
                                    barData(29),
                                    barData(28),
                                    barData(28),
                                    barData(28),
                                    barData(28),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getTextforTiles(double number) {
    return TextStyle(
      color: Colors.white,
    );
  }

  barData(xyvalue) {
    return BarChartGroupData(
      x: xyvalue,
      barRods: [
        BarChartRodData(
          y: xyvalue.toDouble(),
          colors: [
            Colors.amber,
            Colors.red,
            Colors.blue,
          ],
          width: 20,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }
}
