import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User userdata;

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        // appBar: commonAppBar('Profile', this.context),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 20, left: 25, bottom: 5, right: 25),
            child: ListView(
              children: <Widget>[
                Text(userdata.email + "ASd ASD asd ASd ASd aSD ASd aSd"),
                SizedBox(
                  height: 200,
                ),
                Text(userdata.email),
                SizedBox(
                  height: 200,
                ),
                Text(userdata.email),
                SizedBox(
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
