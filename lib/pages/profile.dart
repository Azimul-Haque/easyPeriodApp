import 'package:easyperiod/pages/profile_pages/changepass.dart';
import 'package:easyperiod/pages/profile_pages/feedback.dart';
import 'package:easyperiod/pages/profile_pages/myaccount.dart';
import 'package:easyperiod/pages/profile_pages/notifications.dart';
import 'package:easyperiod/pages/profile_pages/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                    fit: StackFit.expand,
                    // overflow: Overflow.visible,
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/user.png"),
                      ),
                    ],
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
}
