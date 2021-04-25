import 'package:easyperiod/globals.dart';
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
    return new Scaffold(
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
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
        child: Column(
          children: <Widget>[
            Text("Coming soon..."),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (await canLaunch("https://orbachinujbuk.com")) {
                  await launch("https://orbachinujbuk.com");
                } else {
                  throw 'Could not launch!';
                }
              },
              child: Text("Check for updates"),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 160,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/faded/13.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
