import 'dart:async';

import 'package:easyperiod/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedBack extends StatefulWidget {
  FeedBack({Key key}) : super(key: key);
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  var formKey = GlobalKey<FormState>();
  User userdata;

  var feedbackController = TextEditingController();
  var feedback;

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
          title: Text('Feedback'),
          flexibleSpace: appBarStyle(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
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
                        controller: feedbackController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: "Write your feedback",
                          prefixIcon: Icon(Icons.edit),
                        ),
                        validator: (value) {
                          if (value.length == 0) {
                            return "Please write a something.";
                          }
                          return null;
                        },
                        maxLength: 200,
                        onSaved: (value) {
                          setState(() {
                            this.feedback = value.trim();
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
                    onPressed: sendFeedback,
                    icon: Icon(Icons.send_outlined),
                    label: Text("Send Feedback"),
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
                    child: Image.asset("assets/images/faded/3.png"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendFeedback() {
    if (formKey.currentState.validate()) {
      showAlertDialog(context, "Sending feedback...");
      FocusScope.of(context).unfocus();
      formKey.currentState.save();

      // apatoto
      this.showSnackBarandPop();

      // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      // User currentUser = firebaseAuth.currentUser;

      // currentUser.updatePassword(feedback).then((_) {
      //   this.showSnackBarandPop();
      // }).catchError((error) {
      //   print(error.code);
      //   if (error.code == "requires-recent-login") {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         behavior: SnackBarBehavior.floating,
      //         content: Text(error.message),
      //       ),
      //     );
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         behavior: SnackBarBehavior.floating,
      //         content: Text("Error! Try again."),
      //       ),
      //     );
      //   }
      //   Navigator.of(context).pop();
      // });
    }
  }

  showSnackBarandPop() {
    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Thanks for your feedback!"),
        ),
      );
      Navigator.of(context).pop();
    });
  }
}
