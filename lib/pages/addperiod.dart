import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyperiod/home.dart';
import 'package:easyperiod/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:intl/intl.dart';
import 'package:easyperiod/globals.dart';
import 'package:flutter/material.dart';
import 'package:easyperiod/TimeZone.dart';
import 'package:timezone/timezone.dart' as tz;

class Addperiod extends StatefulWidget {
  @override
  _AddperiodState createState() => _AddperiodState();
}

class _AddperiodState extends State<Addperiod> {
  var formKey = GlobalKey<FormState>();
  var startController = TextEditingController();
  var endController = TextEditingController();
  var descController = TextEditingController();
  var start;
  var end;
  var desc;
  User userdata;

  DateTime selectedDate = DateTime.now();
  Future _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(selectedDate.year - 2),
      // lastDate: DateTime(selectedDate.year + 2),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        controller.text = DateFormat('MMMM dd, yyyy').format(picked);
      });
  }

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
  }

  addPeriod() async {
    if (formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      formKey.currentState.save();
      await flutterLocalNotificationsPlugin.cancelAll();
      this.scheduleNotification(
          start,
          1,
          8,
          0,
          "Pay attention to diet nutrition.",
          "Eat more food with rich vitamin.");
      this.scheduleNotification(start, 3, 20, 1, "Period ended? Record then...",
          "Let us help with your menstrual periods.");
      this.scheduleNotification(
          start,
          8,
          9,
          2,
          "Feeling refreshed? You should!",
          "These days are the best among the cycle.");
      this.scheduleNotification(start, 19, 8, 3, "Be careful of acne!",
          "The sebaceous glands are running at full speed.");
      this.scheduleNotification(
          start,
          12,
          8,
          4,
          "You are on your Fertility Phase",
          "Today is one of your most fertile days.");
      this.scheduleNotification(
          start,
          13,
          8,
          5,
          "Today is the Probable ovulation day.",
          "Today is probably your most fertile day.");
      this.scheduleNotification(
          start,
          14,
          8,
          6,
          "You are on your Fertility Phase",
          "Today is one of your fertile days.");
      this.scheduleNotification(
          start,
          26,
          8,
          7,
          "Period starts in today/tomorrow",
          "Get yourself equipped with menstrual items.");
      this.scheduleNotification(
          start,
          26,
          20,
          8,
          "Period starts in today/tomorrow",
          "Get yourself equipped with menstrual items.");
      this.scheduleNotification(
          start,
          27,
          8,
          9,
          "Period starts in today/tomorrow",
          "Get yourself equipped with menstrual items.");
      this.scheduleNotification(
          start,
          28,
          8,
          10,
          "Period starts in today/tomorrow",
          "Get yourself equipped with menstrual items.");
      this.scheduleNotification(
          start,
          29,
          8,
          11,
          "Period starts in today/tomorrow",
          "Get yourself equipped with menstrual items.");
      this.scheduleNotification(
          start,
          30,
          8,
          12,
          "Period starts in today/tomorrow",
          "Get yourself equipped with menstrual items.");

      // print(start);
      // print(end);
      Map<String, dynamic> perioddata = {
        "uid": userdata.uid,
        "start": start,
        "end": end,
        "desc": desc,
      };
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('periods');
      collectionReference
          .add(perioddata)
          .then(
            (value) => this.showSnackBarandPop(),
          )
          // ignore: return_of_invalid_type_from_catch_error
          .catchError(
            (e) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text("Error: " + e.message),
              ),
            ),
          );
    }
  }

  // addDaily() {
  //   print("click");
  //   for (var i = 1; i <= 28; i++) {
  //     Map<String, dynamic> perioddata = {
  //       "day": i,
  //       "title": "Test tile for the day " + i.toString(),
  //       "message": "Test message for day " + i.toString(),
  //       "banglamessage": "বাংলা ভাষায় মেসেজ, দিন সংখ্যাঃ " + i.toString(),
  //     };
  //     CollectionReference collectionReference =
  //         FirebaseFirestore.instance.collection('dailymessages');
  //     collectionReference
  //         .add(perioddata)
  //         .then(
  //           (value) => this.showSnackBarandPop(),
  //         )
  //         // ignore: return_of_invalid_type_from_catch_error
  //         .catchError(
  //           (e) => ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               behavior: SnackBarBehavior.floating,
  //               content: Text("Error: " + e.message),
  //             ),
  //           ),
  //         );
  //   }
  // }

  showSnackBarandPop() {
    showAlertDialog(context, "Adding...");
    Timer(Duration(seconds: 1), () async {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Period Added!"),
        ),
      );
      Route route = MaterialPageRoute(builder: (context) => HomePage());
      Navigator.push(context, route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: appBarStyle(),
        title: Text('Add Period'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 15, bottom: 20, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: startController,
                    decoration: InputDecoration(
                      labelText: "Start Date",
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    validator: (value) {
                      if (value.length == 0) {
                        return "Please select a date.";
                      }
                      return null;
                    },
                    onTap: () {
                      _selectDate(context, startController);
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    onSaved: (value) {
                      setState(() {
                        this.start = value.length > 0
                            ? DateFormat('MMMM dd, yyyy')
                                .parse(value)
                                .toString()
                                .substring(0, 10)
                            : '';
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: endController,
                    decoration: InputDecoration(
                      labelText: "End Date (You can add later)",
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    onTap: () {
                      _selectDate(context, endController);
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    onSaved: (value) {
                      setState(() {
                        end = value.length > 0
                            ? DateFormat('MMMM dd, yyyy')
                                .parse(value)
                                .toString()
                                .substring(0, 10)
                            : '';
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: descController,
                    decoration: InputDecoration(
                      labelText: "Anything you want to add. (Optional)",
                      prefixIcon: Icon(Icons.edit),
                    ),
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        desc = value.trim();
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: addPeriod,
                icon: Icon(CupertinoIcons.drop),
                label: Text("Save Period"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scheduleNotification(date, plusday, plushour, id, title, message) async {
    var scheduledNotificationDateTime =
        DateTime.parse(date).add(Duration(days: plusday, hours: plushour));
    print(scheduledNotificationDateTime);
    // print(scheduledNotificationDateTime.difference(DateTime.now()).inHours);

    // if 'time is not future' handled.
    if (scheduledNotificationDateTime.difference(DateTime.now()).inHours > 0) {
      final timeZone = TimeZone();
      String timeZoneName = await timeZone.getTimeZoneName();
      final location = await timeZone.getLocation(timeZoneName);
      final scheduletztime =
          tz.TZDateTime.from(scheduledNotificationDateTime, location);

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'alarm_notif',
        'alarm_notif',
        'Channel for Alarm notification',
        importance: Importance.max,
        icon: 'ic_stat_onesignal_default',
        // sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
        largeIcon: DrawableResourceAndroidBitmap('ic_stat_onesignal_default'),
      );

      var platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        message,
        scheduletztime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: null,
      );
      print("Notification scheduled: " + id.toString());
    }
  }
}
