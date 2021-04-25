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
    var screenheight = MediaQuery.of(context).size.height;
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        // appBar: commonAppBar('Period Calendar', this.context),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: screenheight / 1.8,
                padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 5),
                child: SfCalendar(
                  monthViewSettings: MonthViewSettings(
                    appointmentDisplayCount: 2,
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment,
                  ),
                  view: CalendarView
                      .month, // calender > settings > month_view_settings (this.appointmentDisplayCount = 2, this.navigationDirection = MonthNavigationDirection.horizontal,)
                  dataSource: PeriodDataSource(getPeriods()),
                  onTap: (CalendarTapDetails details) {
                    // DateTime date = details.date;
                    dynamic appointments = details.appointments;
                    // CalendarElement view = details.targetElement;
                    print(appointments[0].notes);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 50,
                  right: 50,
                  bottom: 50,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  child: Image.asset("assets/images/faded/7.png"),
                ),
              ),
            ],
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
    // period
    periods.add(Appointment(
      startTime: DateTime(startTime.year, startTime.month, startTime.day),
      endTime: DateTime(endTime.year, endTime.month, endTime.day),
      subject: periodslist[i]['desc'],
      color: Colors.red,
      notes: "Period",
      isAllDay: true,
    ));
    // fertility period
    periods.add(Appointment(
      startTime: DateTime(startTime.year, startTime.month, startTime.day + 7),
      endTime: DateTime(startTime.year, startTime.month, startTime.day + 18),
      subject: "Fertile phase",
      color: Colors.lightBlue,
      notes: "Fertility",
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
