import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyperiod/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  Notifications({Key key}) : super(key: key);
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  User userdata;
  List<QueryDocumentSnapshot> periodslist = [];
  List notificationlist = [];
  var startdate;

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
    this.fetchLastPeriod();
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
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: notificationlist.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: ValueKey(
                        notificationlist.elementAt(index),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.notifications_none,
                          color: Colors.red,
                        ),
                        title: Text(
                          notificationlist[index]["title"],
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(notificationlist[index]["body"]),
                        // trailing: Icon(Icons.swipe),
                        onTap: () {},
                      ),
                      background: Container(
                        color: Colors.grey[300],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 0,
                  left: screenwidth * .30,
                  right: screenwidth * .30,
                  bottom: 0,
                ),
                child: ClipRRect(
                  child: Image.asset("assets/images/faded/14.png"),
                ),
              ),
            ],
          )),
    );
  }

  fetchLastPeriod() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('periods');

    collectionReference
        .where('uid', isEqualTo: userdata.uid)
        .orderBy('start', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        periodslist = snapshot.docs;
      });
      startdate = DateTime.parse(periodslist[0]["start"]);
      this.generateAllNotification();
    });
  }

  generateAllNotification() {
    var targetdate1 = DateFormat('MMMM dd, yyyy')
        .format(DateTime.parse(startdate.toString()).add(Duration(days: 1)));
    // print(targetdate1);
    Map<dynamic, dynamic> notificationdata1 = {
      "title": targetdate1 + ": Pay attention to diet nutrition.",
      "body": "Eat more food with rich vitamin.",
    };
    notificationlist.add(notificationdata1);

    var targetdate2 = DateFormat('MMMM dd, yyyy')
        .format(DateTime.parse(startdate.toString()).add(Duration(days: 3)));
    // print(targetdate2);
    Map<dynamic, dynamic> notificationdata2 = {
      "title": targetdate2 + ": Period ended? Record then...",
      "body": "Let us help with your menstrual periods.",
    };
    notificationlist.add(notificationdata2);

    var targetdate3 = DateFormat('MMMM dd, yyyy')
        .format(DateTime.parse(startdate.toString()).add(Duration(days: 9)));
    // print(targetdate3);
    Map<dynamic, dynamic> notificationdata3 = {
      "title": targetdate3 + ": Feeling refreshed? You should!",
      "body": "These days are the best among the cycle.",
    };
    notificationlist.add(notificationdata3);

    var targetdate4 = DateFormat('MMMM dd, yyyy')
        .format(DateTime.parse(startdate.toString()).add(Duration(days: 19)));
    // print(targetdate4);
    Map<dynamic, dynamic> notificationdata4 = {
      "title": targetdate4 + ": Be careful of acne!",
      "body": "The sebaceous glands are running at full speed.",
    };
    notificationlist.add(notificationdata4);

    var targetdate5 = DateFormat('MMMM dd, yyyy')
        .format(DateTime.parse(startdate.toString()).add(Duration(days: 12)));
    // print(targetdate5);
    Map<dynamic, dynamic> notificationdata5 = {
      "title": targetdate5 + ": You are on your Fertility Phase",
      "body": "Today is one of your most fertile days.",
    };
    notificationlist.add(notificationdata5);

    var targetdate6 = DateFormat('MMMM dd, yyyy')
        .format(DateTime.parse(startdate.toString()).add(Duration(days: 13)));
    // print(targetdate6);
    Map<dynamic, dynamic> notificationdata6 = {
      "title": targetdate6 + ": Today is the Probable ovulation day.",
      "body": "Today is probably your most fertile day.",
    };
    notificationlist.add(notificationdata6);

    var targetdate7 = DateFormat('MMMM dd, yyyy')
        .format(DateTime.parse(startdate.toString()).add(Duration(days: 14)));
    // print(targetdate7);
    Map<dynamic, dynamic> notificationdata7 = {
      "title": targetdate7 + ": You are on your Fertility Phase",
      "body": "Today is one of your fertile days.",
    };
    notificationlist.add(notificationdata7);

    var targetdate8 = DateFormat('MMMM dd, yyyy')
        .format(DateTime.parse(startdate.toString()).add(Duration(days: 26)));
    // print(targetdate8);
    Map<dynamic, dynamic> notificationdata8 = {
      "title": targetdate8 + ": Period starts in today/tomorrow",
      "body": "Get yourself equipped with menstrual items.",
    };
    notificationlist.add(notificationdata8);

    var targetdate9 = DateFormat('MMMM dd, yyyy')
        .format(DateTime.parse(startdate.toString()).add(Duration(days: 27)));
    // print(targetdate9);
    Map<dynamic, dynamic> notificationdata9 = {
      "title": targetdate9 + ": Period starts in today/tomorrow",
      "body": "Get yourself equipped with menstrual items.",
    };
    notificationlist.add(notificationdata9);

    return notificationlist;
  }
}
