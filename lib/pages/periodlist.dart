import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easyperiod/globals.dart';

import 'editperiod.dart';

class Periodlist extends StatefulWidget {
  Periodlist({Key key}) : super(key: key);
  @override
  _PeriodlistState createState() => _PeriodlistState();
}

class _PeriodlistState extends State<Periodlist> {
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  User userdata;
  bool isLoading;

  List<QueryDocumentSnapshot> periodslist = [];

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
    isLoading = true;
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
        isLoading = false;
      });
    });
  }

  Future<Null> refreshList() async {
    setState(() {
      isLoading = true;
    });
    this.fetchPeriods();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: const Text('Loaded successfully.'),
      ),
    );
    return null;
  }

  listPopUpMenu(period) {
    return PopupMenuButton(
      // offset: Offset(0, 10),
      onSelected: (value) async {
        switch (value) {
          case 'edit':
            Route route =
                MaterialPageRoute(builder: (context) => Editperiod(period));
            Navigator.push(context, route);
            break;
          case 'delete':
            deletePeriodDialogue(period.reference.id);
            break;
          default:
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: "edit",
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.edit,
                  color: Colors.black87,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Edit Period")
              ],
            ),
          ),
          PopupMenuItem(
            value: "delete",
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.delete_outline,
                  color: Colors.black87,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Delete Period")
              ],
            ),
          ),
        ];
      },
    );
  }

  deletePeriodDialogue(periodrefid) async {
    AlertDialog alert = AlertDialog(
      title: Center(child: Text('Delete Confirmation')),
      content: Text(
        "Do you want to delete this Period?",
        style: TextStyle(fontSize: 15.5, height: 1.2),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text("Yes, Delete"),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('periods')
                .doc(periodrefid)
                .delete();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: const Text('Period Deleted.'),
              ),
            );
          },
        ),
        ElevatedButton(
          child: Text("Back"),
          style: ElevatedButton.styleFrom(
            primary: Colors.grey[350],
            onPrimary: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        appBar: commonAppBar('Period List', this.context),
        body: RefreshIndicator(
          key: refreshKey,
          onRefresh: () async {
            await refreshList();
          },
          child: Column(
            children: <Widget>[
              Visibility(
                visible: isLoading,
                child: LinearProgressIndicator(backgroundColor: Colors.black12),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: periodslist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(CupertinoIcons.drop),
                        ),
                        title: Wrap(children: [
                          Text(
                            (DateFormat('MMMM dd, yyyy').format(
                                    DateFormat('yyyy-MM-dd')
                                        .parse(periodslist[index]['start'])))
                                .toString(),
                            style: new TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            periodslist[index]['end'] != ""
                                ? "- " +
                                    (DateFormat('MMMM dd, yyyy').format(
                                            DateFormat('yyyy-MM-dd').parse(
                                                periodslist[index]['end'])))
                                        .toString()
                                : "",
                            style: new TextStyle(
                              fontSize: 14,
                            ),
                          )
                        ]),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(periodslist[index]['desc']),
                            Wrap(
                              children: <Widget>[
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    child: (periodslist[index]['end'] != "")
                                        ? Text(
                                            (DateTime.parse(periodslist[index]
                                                                ['end'])
                                                            .difference(DateTime
                                                                .parse(periodslist[
                                                                        index]
                                                                    ['start']))
                                                            .inDays +
                                                        1)
                                                    .toString() +
                                                " days",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.red,
                                            ),
                                          )
                                        : periodslist.isNotEmpty
                                            ? Text(
                                                "1 day",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.red,
                                                ),
                                              )
                                            : Text(
                                                "0 day",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.red,
                                                ),
                                              ),
                                  ),
                                ),
                                LinearProgressIndicator(
                                  value: periodslist[index]['end'] != ""
                                      ? (DateTime.parse(
                                                      periodslist[index]['end'])
                                                  .difference(DateTime.parse(
                                                      periodslist[index]
                                                          ['start']))
                                                  .inDays +
                                              1) /
                                          30
                                      : periodslist.isNotEmpty
                                          ? 0.033
                                          : 0.0,
                                  backgroundColor: Colors.grey[350],
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: listPopUpMenu(periodslist[index]),
                        // trailing: Wrap(
                        //   spacing: 5, // space between two icons
                        //   children: <Widget>[
                        //     Icon(Icons.call), // icon-1
                        //     Icon(Icons.message), // icon-2
                        //   ],
                        // ),
                      ),
                      margin: EdgeInsets.only(
                          top: 5, right: 10, bottom: 5, left: 10),
                      elevation: 2,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
