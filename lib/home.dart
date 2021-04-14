import 'package:easyperiod/pages/addperiod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:easyperiod/pages/dashboard.dart';
import 'package:easyperiod/pages/periodlist.dart';
import 'package:easyperiod/pages/calendar.dart';
import 'package:easyperiod/pages/profile.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    Dashboard(),
    Periodlist(),
    Calendar(),
    Profile(),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Dashboard();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(CupertinoIcons.drop),
        onPressed: () {
          Route route = MaterialPageRoute(builder: (context) => Addperiod());
          Navigator.push(context, route);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 7,
        child: Container(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            Dashboard(); // if user taps on this dashboard tab will be active
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.dashboard,
                          color:
                              currentTab == 0 ? Colors.red : Colors.grey[600],
                        ),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                              color: currentTab == 0
                                  ? Colors.red
                                  : Colors.grey[600],
                              fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            Periodlist(); // if user taps on this dashboard tab will be active
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.chat,
                          color:
                              currentTab == 1 ? Colors.red : Colors.grey[600],
                        ),
                        Text(
                          'Period List',
                          style: TextStyle(
                              color: currentTab == 1
                                  ? Colors.red
                                  : Colors.grey[600],
                              fontSize: 11.5),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            Calendar(); // if user taps on this dashboard tab will be active
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.dashboard,
                          color:
                              currentTab == 2 ? Colors.red : Colors.grey[600],
                        ),
                        Text(
                          'Calendar',
                          style: TextStyle(
                              color: currentTab == 2
                                  ? Colors.red
                                  : Colors.grey[600],
                              fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            Profile(); // if user taps on this dashboard tab will be active
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.chat,
                          color:
                              currentTab == 3 ? Colors.red : Colors.grey[600],
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                              color: currentTab == 3
                                  ? Colors.red
                                  : Colors.grey[600],
                              fontSize: 11.5),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
