import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easyperiod/globals.dart';

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
            // qstnReportController.clear();
            // showReportDialog(question);
            break;
          case 'makefavorite':
            // makeFavorite(question);
            break;
          case 'makeunfavorite':
            // makeUnfavorite(question);
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
          // PopupMenuItem(
          //   value: (question.isfav == 0) ? "makefavorite" : "makeunfavorite",
          //   child: (question.isfav == 0)
          //       ? Row(
          //           children: <Widget>[
          //             Icon(
          //               Icons.favorite_border,
          //               color: Colors.black87,
          //             ),
          //             SizedBox(
          //               width: 10,
          //             ),
          //             Text("প্রিয় তালিকায় যোগ করুন")
          //           ],
          //         )
          //       : Row(
          //           children: <Widget>[
          //             Icon(
          //               Icons.remove_circle_outline,
          //               color: Colors.black87,
          //             ),
          //             SizedBox(
          //               width: 10,
          //             ),
          //             Text("প্রিয় তালিকা থেকে অপসারণ করুন")
          //           ],
          //         ),
          // ),
        ];
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
                          ],
                        ),
                        trailing: listPopUpMenu(periodslist[index]),
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
