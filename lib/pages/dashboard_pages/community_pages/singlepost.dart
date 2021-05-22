import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:easyperiod/globals.dart';

class SinglePost extends StatefulWidget {
  final postdata;
  SinglePost(this.postdata);
  @override
  _SinglePostState createState() => _SinglePostState(this.postdata);
}

class _SinglePostState extends State<SinglePost> {
  var postdata;
  _SinglePostState(this.postdata);
  User userdata;
  ScrollController _scrollController = new ScrollController();
  var formKey = GlobalKey<FormState>();
  var replyController = TextEditingController();
  var reply;

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: AppBar(
        title: Text('Single Post'),
        flexibleSpace: appBarStyle(),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(CupertinoIcons.multiply),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildPostWidget(postdata),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                ' Answers',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.blue,
                ),
              ),
            ),

            // replies
            // replies
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 5),
              scrollDirection: Axis.vertical,
              itemCount: postdata['easyperiodpostreplies'].length,
              itemBuilder: (BuildContext context, int index) {
                Widget retWdgt;
                if (postdata['easyperiodpostreplies'].length > 0) {
                  retWdgt = _buildReplyWidget(
                      postdata['easyperiodpostreplies'][index]);
                } else {
                  retWdgt = Container(
                    padding: EdgeInsets.all(20.0),
                    alignment: Alignment.center,
                    child: Text(
                      'No reply.',
                      style: TextStyle(
                        color: Colors.black38,
                      ),
                    ),
                  );
                }
                return retWdgt;
              },
            ),
            SizedBox(
              height: 75,
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.blue[100]),
          ),
        ),
        height: 75,
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Container(
              width: (screenwidth - 20) * 0.82,
              child: Form(
                key: formKey,
                child: SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: replyController,
                    style: TextStyle(
                      fontSize: 13.0,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: new BorderSide(
                          color: Colors.blue[200],
                        ),
                      ),
                      labelText: "Write reply",
                    ),
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        reply = value.trim();
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: (screenwidth - 20) * 0.03,
            ),
            Container(
              width: (screenwidth - 20) * 0.15,
              height: 60,
              child: ElevatedButton(
                onPressed: submitReply,
                child: Icon(Icons.send),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[200],
                  elevation: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildPostWidget(post) {
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
                              userdata.uid == post['uid']
                                  ? post['anonymous'] + ' (You)'
                                  : post['anonymous'],
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
        ],
      ),
    );
  }

  _buildReplyWidget(reply) {
    // print(reply);
    if (reply == null) {
      return Container();
    }
    return Card(
      margin: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 5),
      color: Colors.blue[50],
      elevation: 0.5,
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
                        Expanded(
                          flex: 0,
                          child: SizedBox(
                            width: 30.0,
                            height: 30.0,
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
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                userdata.uid == reply['uid']
                                    ? reply['anonymous'] + ' (You)'
                                    : reply['anonymous'],
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                (DateFormat('MMMM dd, yyyy').format(
                                        DateFormat('yyyy-MM-dd')
                                            .parse(reply['created_at'])))
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              userdata.uid == reply['uid']
                                  ? IconButton(
                                      iconSize: 18,
                                      color: Colors.red,
                                      icon: Icon(CupertinoIcons.delete),
                                      onPressed: () => deleteReply(reply),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      reply['reply'],
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    // Divider(
                    //   color: Colors.black26,
                    //   thickness: .75,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: <Widget>[
                    //     Text(
                    //       reply['easyperiodpostreplies'].length.toString() +
                    //           ' Answer(s)',
                    //       style: TextStyle(
                    //         fontSize: 11,
                    //         color: Colors.blue,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  submitReply() async {
    if (formKey.currentState.validate()) {
      if (replyController.text.length == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Write something.'),
          ),
        );
      } else {
        showAlertDialog(context, "Submitting reply...");
        FocusScope.of(context).unfocus();
        formKey.currentState.save();

        var replydata = {
          'easyperiodpost_id': postdata['id'],
          'uid': userdata.uid,
          'anonymous': 'Anonymous', // kaaj ache
          'reply': reply,
          'created_at':
              (DateFormat('yyyy-mm-dd').format(DateTime.now())).toString()
        };

        // print(replydata);

        try {
          http.Response response = await http.post(
            Uri.parse(
              "http://192.168.0.104:8000/dashboard/easyperiod/store/post/reply/api",
            ),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=utf-8',
              'Accept': 'application/json',
            },
            body: jsonEncode(replydata),
          );
          // print(response.statusCode);
          if (response.statusCode == 200) {
            var body = json.decode(response.body);
            if (body["success"] == true) {
              replyController.clear();
              this.showSnackBarandPop('Thanks for your reply.');
              setState(() {
                replydata['id'] = body["reply"]['id'];
                postdata['easyperiodpostreplies'].insert(0, replydata);
              });
              // print(postdata['easyperiodpostreplies'].length);
              _scrollController.animateTo(0,
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(milliseconds: 500));
            }
          } else {
            // print(response.statusCode);
            Navigator.of(context, rootNavigator: true).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text("Error! Try again."),
              ),
            );
          }
        } catch (_) {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("No internet connection!"),
            ),
          );
          // print(_);
        }
      }
    }
  }

  showSnackBarandPop(text) {
    Timer(Duration(seconds: 1), () {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(text),
        ),
      );
      // Navigator.of(context).pop();
    });
  }

  deleteReply(reply) async {
    AlertDialog alert = AlertDialog(
      title: Center(child: Text('Delete Confirmation')),
      content: Text(
        "Are you sure to delete this reply?",
        style: TextStyle(fontSize: 15.5, height: 1.2),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text("Yes, Delete"),
          onPressed: () async {
            try {
              String serviceURL =
                  "http://192.168.0.104:8000/dashboard/easyperiod/delete/post/reply/" +
                      reply['id'].toString() +
                      "/api";
              var response = await http.get(Uri.parse(serviceURL));
              if (response.statusCode == 200) {
                var getdata = json.decode(response.body);
                if (getdata["success"] == true) {
                  this.showSnackBarandPop('Reply deleted.');
                  setState(() {
                    postdata['easyperiodpostreplies'].remove(reply);
                  });
                }
              }
            } catch (_) {
              print(_);
            }
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
}
