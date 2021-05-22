import 'dart:async';
import 'package:easyperiod/pages/dashboard_pages/community.dart';
import 'package:easyperiod/pages/dashboard_pages/community_pages/myposts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easyperiod/TimeZone.dart';
import 'package:easyperiod/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewPost extends StatefulWidget {
  NewPost({Key key}) : super(key: key);
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  var formKey = GlobalKey<FormState>();
  bool isAnoChecked = false;
  User userdata;

  var postController = TextEditingController();
  var post;

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return new WillPopScope(
      onWillPop: () async => true,
      child: new Scaffold(
        appBar: AppBar(
          title: Text('New Post'),
          flexibleSpace: appBarStyle(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 20),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: postController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: "Write your post",
                          prefixIcon: Icon(Icons.edit),
                        ),
                        validator: (value) {
                          if (value.length == 0) {
                            return "Please write a something.";
                          }
                          return null;
                        },
                        maxLength: 1000,
                        onSaved: (value) {
                          setState(() {
                            this.post = value.trim();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CheckboxListTile(
                  title: const Text('Anonymously'),
                  subtitle: Text('Check if you to hide your name'),
                  value: isAnoChecked,
                  onChanged: (bool value) {
                    setState(() {
                      isAnoChecked = value;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: publishPost,
                    icon: Icon(Icons.send_outlined),
                    label: Text("Publish your Post"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: screenwidth * .24,
                    right: screenwidth * .24,
                    bottom: 10,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    child: Image.asset("assets/images/faded/13.png"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  publishPost() async {
    if (formKey.currentState.validate()) {
      showAlertDialog(context, "Publishing your Post...");
      FocusScope.of(context).unfocus();
      formKey.currentState.save();

      var anonymous;
      if (isAnoChecked == true) {
        anonymous = 'Anonymous';
      } else {
        anonymous = userdata.displayName;
      }
      var newpostdata = {
        'uid': userdata.uid,
        'anonymous': anonymous,
        'body': post,
      };

      try {
        http.Response response = await http.post(
          Uri.parse(
            "https://cvcsbd.com/dashboard/easyperiod/store/post/api",
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
            'Accept': 'application/json',
          },
          body: jsonEncode(newpostdata),
        );
        // print(response.statusCode);
        if (response.statusCode == 200) {
          var body = json.decode(response.body);
          if (body["success"] == true) {
            this.showSnackBarandPop('Your Post has been published.');
          }
        } else {
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

  showSnackBarandPop(text) {
    Timer(Duration(seconds: 1), () {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(text),
        ),
      );
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Route route = MaterialPageRoute(builder: (context) => Community());
      Navigator.push(context, route);
    });
  }
}
