import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drag_down_to_pop/drag_down_to_pop.dart';
import 'package:easyperiod/pages/dashboard_pages/graph.dart';
import 'package:easyperiod/pages/dashboard_pages/insights.dart';
import 'package:easyperiod/pages/dashboard_pages/prediction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
    this.fetchLastPeriod();
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
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image:
                                          AssetImage("assets/images/user.png"),
                                      fit: BoxFit.contain),
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
                    height: 100,
                    padding:
                        EdgeInsets.only(top: 0, left: 10, bottom: 5, right: 10),
                    child: Card(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Mesasge for the day"),
                                Text("Mesasge for the day"),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: <Widget>[
                                //     Text("Test"),
                                //     Text("Test"),
                                //   ],
                                // ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/faded/2.png"),
                                  fit: BoxFit.contain),
                            ),
                          ),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // Navigator.pushNamed(context, routename); // replace routename
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
                          padding: EdgeInsets.only(
                              top: 5, left: 0, bottom: 5, right: 2.5),
                          child: _homeCard(
                              "4.png", "Prediction", "", Prediction(startdate)),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 5, left: 2.5, bottom: 5, right: 2.5),
                          child: _homeCard("4.png", "Graph", "", Graph()),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 5, left: 2.5, bottom: 5, right: 0),
                          child: _homeCard("4.png", "Insights", "", Insights()),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 7,
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     Expanded(
                  //       child: Container(
                  //         padding: EdgeInsets.only(
                  //             top: 5, left: 0, bottom: 5, right: 2.5),
                  //         child: _homeCard("4.png", "A", "পুরো সংবিধান", 'N/A'),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Container(
                  //         padding: EdgeInsets.only(
                  //             top: 5, left: 2.5, bottom: 5, right: 0),
                  //         child: _homeCard("4.png", "C",
                  //             "সংবিধান থেকে প্রশ্ন ও উত্তর", 'N/A'),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //   ],
                  // ),
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

  Widget _homeCard(String image, String title, String takenby, routename) {
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
                  padding: EdgeInsets.all(7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Text(
                      //   takenby,
                      //   style: TextStyle(
                      //       color: Colors.blueGrey,
                      //       fontSize: 11.5,
                      //       height: 1.0),
                      // ),
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
                    // Navigator.pushNamed(context, routename);
                    Navigator.push(
                      context,
                      ImageViewerPageRoute(
                        builder: (context) => routename,
                      ),
                    );
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
    });
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
