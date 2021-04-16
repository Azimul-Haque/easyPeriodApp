import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:easyperiod/globals.dart';
import 'package:flutter/material.dart';

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
        lastDate: DateTime(selectedDate.year + 2));
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

  addPeriod() {
    print(start);
    // Map<String, dynamic> perioddata = {
    //   "uid": "234ASD324234sdf",
    //   "start": "2021-04-12",
    //   "end": "2021-04-15",
    //   "description": null,
    // };
    // CollectionReference collectionReference =
    //     FirebaseFirestore.instance.collection('periods');
    // collectionReference
    //     .add(perioddata)
    //     .then(
    //       (value) => ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           behavior: SnackBarBehavior.floating,
    //           content: Text("Added!"),
    //         ),
    //       ),
    //     )
    //     // ignore: return_of_invalid_type_from_catch_error
    //     .catchError((e) => print(e.message));
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
                    showCursor: false,
                    readOnly: true,
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
                        start = value.trim();
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: endController,
                    showCursor: false,
                    readOnly: true,
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
                        end = value.trim();
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
}
