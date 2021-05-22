import 'dart:convert';
import 'package:easyperiod/pages/dashboard_pages/community_pages/singlepost.dart';
import 'package:intl/intl.dart';
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
  ScrollController _scrollController = new ScrollController();
  bool nonewspost = false;

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
    this.getPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        this.getPosts();
        // print("Works");
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var screenwidth = MediaQuery.of(context).size.width;
    return new Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.only(top: 5),
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        itemCount: posts.length > 0 && posts.length < 7
            ? posts.length
            : posts.length >= 7
                ? posts.length + 1
                : posts.length + 5,
        itemBuilder: (BuildContext context, int index) {
          Widget retWdgt;
          if (posts.length > 0) {
            if (index < posts.length) {
              retWdgt = _buildPreviewWidget(posts[index]);
            } else {
              if (nonewspost == false) {
                return _shimmer();
              } else {
                return Container(
                  padding: EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: Text(
                    'No more to show.',
                    style: TextStyle(
                      color: Colors.black38,
                    ),
                  ),
                );
              }
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 10.0),
              //   child: Center(child: CircularProgressIndicator()),
              // );
            }
          } else {
            retWdgt = _shimmer();
          }
          return retWdgt;
        },
      ),
    );
  }

  getPosts() async {
    try {
      String serviceURL =
          "https://cvcsbd.com/dashboard/easyperiod/global/posts/" +
              posts.length.toString() +
              "/api";
      var response = await http.get(Uri.parse(serviceURL));
      if (response.statusCode == 200) {
        var postdata = json.decode(response.body);
        if (postdata["success"] == true) {
          setState(() {
            posts.addAll(postdata["posts"]);
          });
          if (postdata["posts"].length == 0) {
            nonewspost = true;
          }
          if (posts.length == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('No data to show.'),
              ),
            );
          }
        }
      }
    } catch (_) {
      print(_);
    }
  }

  _buildPreviewWidget(post) {
    // print(post);
    if (post == null) {
      return Container();
    }

    return Card(
      margin: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
      color: Colors.grey[100],
      elevation: 1.5,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.black26,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage("assets/images/user.png"),
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              post['anonymous'],
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              (DateFormat('MMMM dd, yyyy').format(
                                      DateFormat('yyyy-MM-dd')
                                          .parse(post['created_at'])))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      post['body'],
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    Divider(
                      color: Colors.black26,
                      thickness: .75,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          post['easyperiodpostreplies'].length.toString() +
                              ' Answer(s)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
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
                  Route route =
                      MaterialPageRoute(builder: (context) => SinglePost(post));
                  Navigator.push(context, route);
                },
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _shimmer() {
    var screenwidth = MediaQuery.of(context).size.width;
    return Container(
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
}
