import 'package:firebase_auth/firebase_auth.dart';
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
                    height: screenheight * .2,
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
                    child: Center(
                      child: Text(
                        "Welcome\n" + userdata.displayName + "!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Times",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(.5),
                              offset: Offset(2, 2),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text("Test1"),
                  SizedBox(
                    height: 100,
                  ),
                  Text("Test2"),
                  SizedBox(
                    height: 100,
                  ),
                  Text("Test3"),
                  SizedBox(
                    height: 100,
                  ),
                  Text("Test4"),
                  SizedBox(
                    height: 100,
                  ),
                  Text("Test5"),
                  Text("Test5"),
                  Text("Test5"),
                  Text("Test5"),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
