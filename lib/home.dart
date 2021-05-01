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
  int _selectedItem = 0;
  var _pages = [Dashboard(), Periodlist(), Calendar(), Profile()];
  var _pageController = PageController();

  int get currentIndex => null;

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: commonAppBar(
          _selectedItem == 0
              ? 'EasyPeriod'
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
                    minWidth: screenwidth * .2,
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
                          CupertinoIcons.home,
                          // Icons.dashboard,
                          color: _selectedItem == 0
                              ? Colors.red
                              : Colors.grey[600],
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                              color: _selectedItem == 0
                                  ? Colors.red
                                  : Colors.grey[600],
                              fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: screenwidth * .2,
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
                          CupertinoIcons.list_bullet_indent,
                          // Icons.format_list_numbered_sharp,
                          color: _selectedItem == 1
                              ? Colors.red
                              : Colors.grey[600],
                        ),
                        Text(
                          'Records',
                          style: TextStyle(
                              color: _selectedItem == 1
                                  ? Colors.red
                                  : Colors.grey[600],
                              fontSize: 11),
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
                    minWidth: screenwidth * .2,
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
                          CupertinoIcons.calendar_today,
                          // Icons.calendar_today_outlined,
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
                              fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: screenwidth * .2,
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
                          CupertinoIcons.person,
                          // Icons.person,
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
                              fontSize: 11),
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
