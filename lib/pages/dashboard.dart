import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User userdata;

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
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
                    height: screenheight * .25,
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
                          left: screenwidth * .12,
                          right: screenwidth * .12,
                          bottom: 10),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(screenwidth * .015),
                                width: screenwidth * .16,
                                height: screenwidth * .16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image:
                                          AssetImage("assets/images/user2.png"),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Anindita Mashsharrat Naziba",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(.5),
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
                                        "14 days of last period",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white70,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(.5),
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
                          // Center(
                          //   child: Text(
                          //     "Welcome\n" + userdata.displayName + "!",
                          //     textAlign: TextAlign.center,
                          //     style: TextStyle(
                          //       fontSize: 25,
                          //       fontFamily: "Times",
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.white,
                          //       shadows: [
                          //         Shadow(
                          //           color: Colors.black.withOpacity(.5),
                          //           offset: Offset(2, 2),
                          //           blurRadius: 2,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 10, left: 10, bottom: 2.5, right: 2.5),
                          child: _homeCard(
                              "3.png", "সংবিধান", "পুরো সংবিধান", '/homepage'),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 10, left: 2.5, bottom: 2.5, right: 10),
                          child: _homeCard("4.png", "প্রশ্নোত্তর",
                              "সংবিধান থেকে প্রশ্ন", '/homepage'),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 10, left: 2.5, bottom: 2.5, right: 10),
                          child: _homeCard("3.png", "প্রশ্নোত্তর",
                              "সংবিধান থেকে", '/homepage'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 0, left: 15, bottom: 0, right: 15),
                          child: Text(
                            "Avg Period Graph",
                            style: TextStyle(
                              fontSize: 15,
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
                            margin: EdgeInsets.only(
                                top: 5, left: 15, bottom: 10, right: 15),
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
                                        leftTitles:
                                            SideTitles(showTitles: false),
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
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 5, left: 10, bottom: 5, right: 2.5),
                          child: _homeCard(
                              "3.png", "সংবিধান", "পুরো সংবিধান", '/homepage'),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 5, left: 2.5, bottom: 5, right: 10),
                          child: _homeCard("4.png", "প্রশ্নোত্তর",
                              "সংবিধান থেকে প্রশ্ন ও উত্তর", '/homepage'),
                        ),
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

  Widget _homeCard(
      String image, String title, String takenby, String routename) {
    return Card(
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                child: Image.asset("assets/images/empowerment/" + image),
              ),
              Padding(
                  padding: EdgeInsets.all(7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        takenby,
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 11.5,
                            height: 1.0),
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
                  // if (routename != 'N/A') {
                  //   Navigator.pushNamed(context, routename);
                  // } else {}
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
