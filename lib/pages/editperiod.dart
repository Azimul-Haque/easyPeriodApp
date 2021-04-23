import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:easyperiod/globals.dart';
import 'package:flutter/material.dart';

class Editperiod extends StatefulWidget {
  final data;
  Editperiod(this.data);
  @override
  _EditperiodState createState() => _EditperiodState(this.data);
}

class _EditperiodState extends State<Editperiod> {
  var data;
  _EditperiodState(this.data);

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
    startController.text = DateFormat('MMMM dd, yyyy')
        .format(DateFormat('yyyy-MM-dd').parse(data['start']));
    endController.text = data['end'] != ""
        ? DateFormat('MMMM dd, yyyy')
            .format(DateFormat('yyyy-MM-dd').parse(data['end']))
        : "";
    descController.text = data['desc'];
    start = data['start'];
    end = data['end'];
    desc = data['desc'];
  }

  updatePeriod() {
    if (formKey.currentState.validate()) {
      showAlertDialog(context, "Updating...");
      FocusScope.of(context).unfocus();
      formKey.currentState.save();
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
          .doc(data.reference.id)
          .update(perioddata)
          .then(
            (value) => this.showSnackBarandPop(),
          )
          .catchError(
            // ignore: return_of_invalid_type_from_catch_error
            (e) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text("Error: " + e.message),
              ),
            ),
          );
    }
  }

  showSnackBarandPop() {
    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Period updated."),
        ),
      );
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: appBarStyle(),
        title: Text('Edit Period'),
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
                onPressed: updatePeriod,
                icon: Icon(CupertinoIcons.drop),
                label: Text("Update Period"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
