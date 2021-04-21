import 'package:easyperiod/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  Notifications({Key key}) : super(key: key);
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
      onWillPop: () async => true,
      child: new Scaffold(
        appBar: AppBar(
          title: Text('Notifiactions'),
          flexibleSpace: appBarStyle(),
        ),
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
                      Positioned(
                        right: -16,
                        bottom: 0,
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.grey,
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              print("Clicked!");
                            },
                            child: Icon(Icons.camera_alt_outlined),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  userdata.displayName,
                  style: TextStyle(
                    fontSize: 18,
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
                      size: 35,
                    ),
                    title: Text(
                      'My Account',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () {},
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
                      size: 35,
                    ),
                    title: Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () {},
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
                      size: 35,
                    ),
                    title: Text(
                      'Send Feedback',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.red,
                      size: 35,
                    ),
                    title: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () {},
                    ),
                  ),
                ),
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
