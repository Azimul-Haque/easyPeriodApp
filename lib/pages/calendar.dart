import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  Calendar({Key key}) : super(key: key);
  @override
  _CalendarState createState() => _CalendarState();
}

List<QueryDocumentSnapshot> periodslist = [];

class _CalendarState extends State<Calendar> {
  User userdata;

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
    this.fetchPeriods();
  }

  fetchPeriods() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('periods');

    collectionReference
        .where('uid', isEqualTo: userdata.uid)
        .orderBy('start', descending: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        periodslist = snapshot.docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        // appBar: commonAppBar('Period Calendar', this.context),
        body: Container(
          padding: EdgeInsets.only(
              top: 5,
              left: 5,
              bottom: MediaQuery.of(context).size.height / 3.7,
              right: 5),
          child: SfCalendar(
            view:
                CalendarView.month, // calender > settings > month_view_settings
            dataSource: PeriodDataSource(getPeriods()),
          ),
        ),
      ),
    );
  }
}

List<Appointment> getPeriods() {
  List<Appointment> periods = <Appointment>[];

  for (var i = 0; i < periodslist.length; i++) {
    DateTime startTime = DateTime.parse(periodslist[i]['start']);
    DateTime endTime = periodslist[i]['end'] != ''
        ? DateTime.parse(periodslist[i]['end'])
        : DateTime.parse(periodslist[i]['start']);
    periods.add(Appointment(
      startTime: DateTime(startTime.year, startTime.month, startTime.day),
      endTime: DateTime(endTime.year, endTime.month, endTime.day),
      subject: periodslist[i]['desc'],
      color: Colors.red,
      isAllDay: true,
    ));
  }

  return periods;
}

class PeriodDataSource extends CalendarDataSource {
  PeriodDataSource(List<Appointment> source) {
    appointments = source;
  }
}
