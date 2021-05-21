import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drag_down_to_pop/drag_down_to_pop.dart';
import 'package:easyperiod/pages/dashboard_pages/dailymessage.dart';
import 'package:easyperiod/pages/dashboard_pages/graph.dart';
import 'package:easyperiod/pages/dashboard_pages/insights.dart';
import 'package:easyperiod/pages/dashboard_pages/community.dart';
import 'package:easyperiod/pages/dashboard_pages/prediction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User userdata;
  List<QueryDocumentSnapshot> periodslist = [];
  var startdate;
  var enddate;
  var periodduration = 0;
  var dayscount = 0;
  var todaystitle = "";
  var todaysmessage = "";
  var banglamessage = "";
  var userimagelocal = "";
  List urlcollection = [];

  @override
  void initState() {
    super.initState();
    this._loadSharedData();
    userdata = FirebaseAuth.instance.currentUser;
    this.fetchLastPeriod();
    this.getUserImage();
    this.getArticleList();
  }

  _loadSharedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String spuserimage = (prefs.getString('userImage') ?? '');
    setState(() {
      userimagelocal = (prefs.getString('userImage') ?? '');
    });
    // print(userimagelocal);
  }

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        // appBar: commonAppBar('Dashboard', this.context),
        body: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: screenheight * .135,
                    width: double.infinity,
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        colors: [
                          Colors.red[800],
                          Colors.red[600],
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(35),
                        bottomLeft: Radius.circular(35),
                      ),
                      image: DecorationImage(
                        image: AssetImage("assets/images/faded/1.png"),
                        alignment: Alignment.center,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 0,
                          left: screenwidth * .125,
                          right: screenwidth * .125,
                          bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(screenwidth * .02),
                                width: screenwidth * .15,
                                height: screenwidth * .15,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(75.0),
                                  child: userimagelocal != ''
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              "https://cvcsbd.com/images/easyperiod/users/" +
                                                  userimagelocal,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )
                                      : Image.asset("assets/images/user.png"),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        userdata.displayName,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(.4),
                                              offset: Offset(2, 2),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        dayscount > 6
                                            ? "Day " +
                                                dayscount.toString() +
                                                " of last period"
                                            : "Day " +
                                                dayscount.toString() +
                                                " of current period",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white70,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(.4),
                                              offset: Offset(2, 2),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        height: 250,
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            top: 5, left: 5, bottom: 5, right: 5),
                        child: PieChart(
                          PieChartData(
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 1,
                            startDegreeOffset: -70,
                            centerSpaceRadius: 95,
                            sections: getSectionsforPie(),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              dayscount > 40
                                  ? "Inactive or Pregnant"
                                  : dayscount >= 20
                                      ? "Infertile Phase"
                                      : dayscount == 14
                                          ? "Most Fertile Today"
                                          : dayscount >= 8 && periodduration < 8
                                              ? "Fertile Phase"
                                              : dayscount <= periodduration
                                                  ? "Period"
                                                  : "Fertility Window",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            ),
                            Text(
                              dayscount > 40
                                  ? "Record new period"
                                  : "Day " + dayscount.toString(),
                              style: TextStyle(
                                fontSize: dayscount > 40 ? 20 : 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[900],
                              ),
                            ),
                            Text(
                              DateFormat('MMMM dd, yyyy')
                                  .format(DateTime.now()),
                              style: TextStyle(
                                fontSize: 13.7,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 10, left: 15, bottom: 5, right: 15),
                          child: Text(
                            "Today's Message for you",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    // height: 100,
                    padding:
                        EdgeInsets.only(top: 0, left: 10, bottom: 5, right: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: screenwidth - 130,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        todaystitle,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        todaysmessage,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "See More",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue,
                                  Colors.blue[200],
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 15,
                            bottom: 15,
                            top: 15,
                            child: ClipRRect(
                              child: Image.asset(
                                  "assets/images/dailyicons/sun.png"),
                            ),
                          ),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Route routename = MaterialPageRoute(
                                    builder: (context) => DailyMessage(
                                      [
                                        todaystitle,
                                        todaysmessage,
                                        banglamessage
                                      ],
                                    ),
                                  );
                                  Navigator.push(
                                    context,
                                    routename,
                                  );
                                },
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 10, left: 15, bottom: 0, right: 15),
                          child: Text(
                            "Relevant Stuff",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: screenwidth * .27,
                          padding: EdgeInsets.only(
                              top: 5, left: 0, bottom: 5, right: 2.5),
                          child: _homeCard(
                              "11.png", "Prediction", Prediction(startdate)),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: screenwidth * .27,
                          padding: EdgeInsets.only(
                              top: 5, left: 2.5, bottom: 5, right: 2.5),
                          child: _homeCard("12.png", "Graph", Graph()),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: screenwidth * .27,
                          padding: EdgeInsets.only(
                              top: 5, left: 2.5, bottom: 5, right: 2.5),
                          child: _homeCard(
                              "13.png", "Insights", Insights(urlcollection)),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: screenwidth * .27,
                          padding: EdgeInsets.only(
                              top: 5, left: 2.5, bottom: 5, right: 0),
                          child: _homeCard("14.png", "Community", Community()),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _homeCard(String image, String title, routename) {
    return Card(
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                child: Image.asset("assets/images/empowerment/" + image),
              ),
              Padding(
                  padding: EdgeInsets.all(2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ))
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (routename != 'N/A') {
                    if (title == 'Insights' || title == 'Community') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => routename,
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        ImageViewerPageRoute(
                          builder: (context) => routename,
                        ),
                      );
                    }
                  } else {}
                },
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 2,
    );
  }

  fetchLastPeriod() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('periods');

    collectionReference
        .where('uid', isEqualTo: userdata.uid)
        .orderBy('start', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        periodslist = snapshot.docs;
      });
      startdate = DateTime.parse(periodslist[0]["start"]);
      enddate = periodslist[0]["end"] != ""
          ? DateTime.parse(periodslist[0]["end"])
          : null;
      periodduration =
          enddate != null ? enddate.difference(startdate).inDays + 1 : 4;
      // print(startdate);
      // print(enddate);
      // print(periodduration);
      var today = DateTime.now();
      dayscount = today.difference(startdate).inDays + 1;
      this.fetchTodaysMessage(dayscount);
    });
  }

  fetchTodaysMessage(day) {
    if (day > 29) {
      day = 29;
    }
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('dailymessages');
    try {
      collectionReference
          .where('day', isEqualTo: day) // day
          .limit(1)
          .snapshots()
          .listen((snapshot) {
        setState(() {
          todaystitle = snapshot.docs[0]["title"];
          todaysmessage = snapshot.docs[0]["message"];
          banglamessage = snapshot.docs[0]["banglamessage"];
        });
        // print(todaysmessage);
      });
    } catch (e) {
      print(e);
    }
  }

  getUserImage() async {
    try {
      String serviceURL = "https://cvcsbd.com/dashboard/easyperiod/userimage/" +
          userdata.uid +
          "/api";
      var response = await http.get(Uri.parse(serviceURL));
      // print(response.body);
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        if (body["success"] == true) {
          if (userimagelocal != body["image"]) {
            SharedPreferences spupdateimgdata =
                await SharedPreferences.getInstance();
            setState(() {
              userimagelocal = body["image"];
            });
            spupdateimgdata.setString('userImage', userimagelocal);
          }
          // print(userimagelocal);
        }
      }
    } catch (_) {
      print(_);
    }
  }

  getArticleList() async {
    try {
      String serviceURL = "https://cvcsbd.com/easyperiod/article/list/api";
      var response = await http.get(Uri.parse(serviceURL));
      if (response.statusCode == 200) {
        var articlelist = json.decode(response.body);
        articlelist.forEach((element) {
          // print(urlcollection);
          urlcollection.add('https://cvcsbd.com/easyperiod/' + element);
        });
        // print(urlcollection);
      }
    } catch (_) {
      print(_);
    }
  }

  List<PieChartSectionData> getSectionsforPie() {
    List<PieChartSectionData> sections = <PieChartSectionData>[];

    for (var i = 1; i <= periodduration; i++) {
      sections.add(PieChartSectionData(
        color: Colors.red,
        value: 1,
        title: i.toString(),
        radius: i == dayscount ? 22 : 16,
        titleStyle: TextStyle(
          fontSize: i == dayscount ? 14 : 12,
          color: const Color(0xffffffff),
          fontWeight: i == dayscount ? FontWeight.bold : FontWeight.normal,
        ),
      ));
    }
    var valuefornextphase1 = periodduration;
    for (var i = 1; i <= 7 - periodduration; i++) {
      sections.add(PieChartSectionData(
        color: Colors.teal[200],
        value: 1,
        title: (valuefornextphase1 + i).toString(),
        radius: (valuefornextphase1 + i) == dayscount ? 22 : 16,
        titleStyle: TextStyle(
          fontSize: (valuefornextphase1 + i) == dayscount ? 14 : 12,
          color: const Color(0xffffffff),
          fontWeight: (valuefornextphase1 + i) == dayscount
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ));
    }
    var valuefornextphase2 = periodduration >= 8 ? periodduration + 1 : 8;
    for (var i = 1; i <= 12; i++) {
      sections.add(PieChartSectionData(
        color: Colors.indigo[300],
        value: 1,
        title: valuefornextphase2.toString(),
        radius: valuefornextphase2 == dayscount ? 22 : 16,
        titleStyle: TextStyle(
          fontSize: valuefornextphase2 == dayscount ? 14 : 12,
          color: const Color(0xffffffff),
          fontWeight: valuefornextphase2 == dayscount
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ));
      valuefornextphase2++;
    }

    // ekhane 9 or 9+ hote paare...
    var valuefornextphase3 = valuefornextphase2;
    var lastperioddays = 9;
    if (dayscount > 28 && dayscount < 41) {
      lastperioddays = dayscount - 28 + 9;
    } else if (dayscount > 40) {
      lastperioddays = 40 - 28 + 9;
    } else {
      lastperioddays = 9;
    }
    for (var i = 1; i <= lastperioddays; i++) {
      sections.add(PieChartSectionData(
        color: Colors.indigo[100],
        value: 1,
        title: valuefornextphase3.toString(),
        radius: valuefornextphase3 == dayscount ? 22 : 16,
        titleStyle: TextStyle(
          fontSize: valuefornextphase3 == dayscount ? 14 : 12,
          color: const Color(0xffffffff),
          fontWeight: valuefornextphase3 == dayscount
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ));
      valuefornextphase3++;
    }

    return sections;
  }
}

class ImageViewerPageRoute extends MaterialPageRoute {
  ImageViewerPageRoute({@required WidgetBuilder builder})
      : super(builder: builder, maintainState: false);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return const DragDownToPopPageTransitionsBuilder()
        .buildTransitions(this, context, animation, secondaryAnimation, child);
  }

  @override
  bool canTransitionFrom(TransitionRoute previousRoute) {
    return false;
  }

  @override
  bool canTransitionTo(TransitionRoute nextRoute) {
    return false;
  }
}
