import 'package:easyperiod/globals.dart';
import 'package:easyperiod/pages/dashboard_pages/community_pages/myposts.dart';
import 'package:easyperiod/pages/dashboard_pages/community_pages/periodtalks.dart';
import 'package:easyperiod/pages/dashboard_pages/graph.dart';
import 'package:easyperiod/pages/dashboard_pages/insights.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Community extends StatefulWidget {
  Community({Key key}) : super(key: key);
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  User userdata;

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    // var screenwidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Community Discussion'),
          flexibleSpace: appBarStyle(),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(CupertinoIcons.multiply),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: "Period Talk"),
              Tab(text: "My Posts"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            PeriodTalks(),
            MyPosts(),
          ],
        ),
      ),
    );
  }
}
