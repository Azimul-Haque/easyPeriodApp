import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class PeriodTalks extends StatefulWidget {
  PeriodTalks({Key key}) : super(key: key);
  @override
  _PeriodTalksState createState() => _PeriodTalksState();
}

class _PeriodTalksState extends State<PeriodTalks> {
  User userdata;
  List posts = [];

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
    this.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return new Scaffold(
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: posts.length > 0 ? posts.length : 3,
        itemBuilder: (BuildContext context, int index) {
          Widget retWdgt;
          if (posts.length > 0) {
            retWdgt = Text(posts[index]['category']);
          } else {
            retWdgt = Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.white24,
                              child: Container(
                                decoration: new BoxDecoration(
                                  color: Colors.white12,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 200.0,
                            height: 10.0,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.white24,
                              child: Container(
                                color: Colors.white12,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 100.0,
                            height: 10.0,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.white24,
                              child: Container(
                                color: Colors.white12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 10.0,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white24,
                      child: Container(
                        color: Colors.white12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 10.0,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white24,
                      child: Container(
                        color: Colors.white12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 10.0,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white24,
                      child: Container(
                        color: Colors.white12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: screenwidth * .5,
                    height: 10.0,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white24,
                      child: Container(
                        color: Colors.white12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return retWdgt;
        },
      ),
    );
  }

  getPosts() async {
    try {
      String serviceURL =
          "http://192.168.0.104:8000/dashboard/easyperiod/global/posts/api";
      var response = await http.get(Uri.parse(serviceURL));
      if (response.statusCode == 200) {
        var postdata = json.decode(response.body);
        if (postdata["success"] == true) {
          setState(() {
            posts = postdata["posts"];
          });
          print(posts);
        }
      }
    } catch (_) {
      print(_);
    }
  }

  _buildPreviewWidget(document) {
    // print(document);
    if (document == null) {
      return Container();
    }

    return Card(
      color: Colors.lightGreen[50],
      elevation: 1.5,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        document['category'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 15),
                      ),
                      Text(
                        document['anonymous'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        document['body'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        document['created_at'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.white12,
                onTap: () {
                  // Route route =
                  //     MaterialPageRoute(builder: (context) => WebPage(url));
                  // Navigator.push(context, route);
                },
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
