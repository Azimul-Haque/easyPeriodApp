library easyperiod.globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'login.dart';

// String userName;
// String userDesig;
// String userOrg;
String userImage;

commonAppBar(String appbarname, BuildContext context) {
  return AppBar(
    elevation: appbarname == 'EasyPeriod' ? 0 : 4,
    title: Text(appbarname),
    automaticallyImplyLeading: false,
    flexibleSpace: appBarStyle(),
    actions: <Widget>[
      PopupMenuButton(
        icon: Icon(CupertinoIcons.line_horizontal_3_decrease),
        // icon: Icon(Icons.filter_list_outlined),
        // offset: Offset(0, 30),
        onSelected: (value) async {
          switch (value) {
            case 'signout':
              await FirebaseAuth.instance.signOut();
              Route route =
                  MaterialPageRoute(builder: (context) => LoginPage());
              Navigator.push(context, route);
              break;
            case 'rate':
              if (await canLaunch("https://orbachinujbuk.com")) {
                await launch(
                    "https://play.google.com/store/apps/details?id=com.orbachinujbuk.easyperiod");
              } else {
                throw 'Could not launch!';
              }
              break;
            case 'shareapp':
              share(
                  "https://play.google.com/store/apps/details?id=com.orbachinujbuk.easyperiod",
                  "EasyPeriod App");
              break;
            case 'aboutus':
              if (await canLaunch("https://orbachinujbuk.com")) {
                await launch("https://orbachinujbuk.com");
              } else {
                throw 'Could not launch!';
              }
              break;
            default:
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              value: "signout",
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.logout,
                    color: Colors.black87,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Sign Out")
                ],
              ),
            ),
            PopupMenuItem(
              value: "rate",
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: Colors.black87,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Rate Us")
                ],
              ),
            ),
            PopupMenuItem(
              value: "shareapp",
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.share,
                    color: Colors.black87,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Share App")
                ],
              ),
            ),
            PopupMenuItem(
              value: "aboutus",
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.info_outline,
                    color: Colors.black87,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("About Us")
                ],
              ),
            ),
          ];
        },
      )
    ],
  );
}

appBarStyle() {
  return Ink(
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
    ),
  );
}

showAlertDialog(BuildContext context, String message) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Center(child: Text(message)),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
      ],
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<void> share(textorurl, subject) async {
  await Share.share(
    subject + ': ' + textorurl,
    subject: subject,
  );
}
