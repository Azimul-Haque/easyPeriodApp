import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyperiod/pages/profile_pages/changepass.dart';
import 'package:easyperiod/pages/profile_pages/feedback.dart';
import 'package:easyperiod/pages/profile_pages/myaccount.dart';
import 'package:easyperiod/pages/profile_pages/notifications.dart';
import 'package:easyperiod/pages/profile_pages/settings.dart';
import 'package:easyperiod/globals.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userimagelocal = "";

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
    this._loadSharedData();
    userdata = FirebaseAuth.instance.currentUser;
    this.getUserImage();
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
    var screenwidth = MediaQuery.of(context).size.width;
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        // appBar: commonAppBar('Profile', this.context),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(screenwidth * .02),
                  width: screenwidth * .30,
                  height: screenwidth * .30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75.0),
                    child: userimagelocal != ''
                        ? CachedNetworkImage(
                            imageUrl:
                                "https://cvcsbd.com/images/easyperiod/users/" +
                                    userimagelocal,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          )
                        : Image.asset("assets/images/user.png"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  userdata.displayName,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      color: Colors.red,
                      size: 30,
                    ),
                    title: Text(
                      'My Account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {},
                    trailing: IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => MyAccount());
                        Navigator.push(context, route).then((value) {
                          setState(() {
                            userdata = FirebaseAuth.instance.currentUser;
                            // image update er kaaj korte hobe...
                            this.getUserImage();
                          });
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.vpn_key_outlined,
                      color: Colors.red,
                      size: 27,
                    ),
                    title: Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {},
                    trailing: IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => ChangePass());
                        Navigator.push(context, route);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.notifications_none,
                      color: Colors.red,
                      size: 30,
                    ),
                    title: Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {},
                    trailing: IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => Notifications());
                        Navigator.push(context, route);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.message_outlined,
                      color: Colors.red,
                      size: 30,
                    ),
                    title: Text(
                      'Send Feedback',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {},
                    trailing: IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () {
                        Route route =
                            MaterialPageRoute(builder: (context) => FeedBack());
                        Navigator.push(context, route);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                // Card(
                //   child: ListTile(
                //     leading: Icon(
                //       Icons.settings,
                //       color: Colors.red,
                //       size: 30,
                //     ),
                //     title: Text(
                //       'Settings',
                //       style: TextStyle(
                //         fontSize: 16,
                //         color: Colors.red,
                //       ),
                //     ),
                //     onTap: () {},
                //     trailing: IconButton(
                //       icon: Icon(Icons.edit_outlined),
                //       onPressed: () {
                //         Route route =
                //             MaterialPageRoute(builder: (context) => Settings());
                //         Navigator.push(context, route);
                //       },
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: screenwidth * .24,
                    right: screenwidth * .24,
                    bottom: 10,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    child: Image.asset("assets/images/faded/3.png"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
}
