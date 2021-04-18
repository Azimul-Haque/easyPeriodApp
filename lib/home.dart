import 'package:easyperiod/pages/addperiod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:easyperiod/pages/dashboard.dart';
import 'package:easyperiod/pages/periodlist.dart';
import 'package:easyperiod/pages/calendar.dart';
import 'package:easyperiod/pages/profile.dart';

import 'globals.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int currentTab = 0; // to keep track of active tab index
  // final List<Widget> screens = [
  //   Dashboard(),
  //   Periodlist(),
  //   Calendar(),
  //   Profile(),
  // ]; // to store nested tabs
  // final PageStorageBucket bucket = PageStorageBucket();
  // Widget currentScreen = Dashboard();

  // test
  int _selectedItem = 0;
  var _pages = [Dashboard(), Periodlist(), Calendar(), Profile()];
  var _pageController = PageController();

  int get currentIndex => null;
  // test

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
          _selectedItem == 0
              ? 'Dashboard'
              : _selectedItem == 1
                  ? 'Period List'
                  : _selectedItem == 2
                      ? 'Period Calendar'
                      : _selectedItem == 3
                          ? 'Profile'
                          : '',
          this.context),
      body: PageView(
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedItem = index;
          });
        },
        controller: _pageController,
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
          height: 60,
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
                        _selectedItem = 0;
                        _pageController.animateToPage(_selectedItem,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.dashboard,
                          color: _selectedItem == 0
                              ? Colors.red
                              : Colors.grey[600],
                        ),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                              color: _selectedItem == 0
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
                        _selectedItem = 1;
                        _pageController.animateToPage(_selectedItem,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.format_list_numbered_sharp,
                          color: _selectedItem == 1
                              ? Colors.red
                              : Colors.grey[600],
                        ),
                        Text(
                          'Period List',
                          style: TextStyle(
                              color: _selectedItem == 1
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
                        _selectedItem = 2;
                        _pageController.animateToPage(_selectedItem,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today_outlined,
                          color: _selectedItem == 2
                              ? Colors.red
                              : Colors.grey[600],
                        ),
                        Text(
                          'Calendar',
                          style: TextStyle(
                              color: _selectedItem == 2
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
                        _selectedItem = 3;
                        _pageController.animateToPage(_selectedItem,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color: _selectedItem == 3
                              ? Colors.red
                              : Colors.grey[600],
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                              color: _selectedItem == 3
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
