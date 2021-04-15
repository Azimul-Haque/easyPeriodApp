import 'dart:math';

import 'package:easyperiod/home.dart';
import 'package:easyperiod/login.dart';
import 'package:easyperiod/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easyperiod/globals.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({Key key}) : super(key: key);
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final randompicnumber = (Random().nextInt(7) + 1).toString();
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var email;

  @override
  void initState() {
    super.initState();
    // FirebaseAuth.instance.authStateChanges().listen((User user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     print('User is signed in!');
    //     // User user = FirebaseAuth.instance.currentUser;
    //     print(user);
    //     Route route = MaterialPageRoute(builder: (context) => HomePage());
    //     Navigator.push(context, route);
    //   }
    // });
  }

  Future<dynamic> login() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Please check password reset email at: " + email),
        ),
      );
      Route route = MaterialPageRoute(builder: (context) => LoginPage());
      Navigator.push(context, route);
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: (e.code == 'user-not-found')
              ? Text("No user found with this email.")
              : (e.code == 'unknown')
                  ? Text("No internet!")
                  : Text("Error! Try again."),
          // content: Text(e.message),
        ),
      );
      Navigator.pop(context);
    }
    return null;
  }

  void handleSubmit() {
    if (formKey.currentState.validate()) {
      showAlertDialog(context, "Sending email...");
      FocusScope.of(context).unfocus();
      formKey.currentState.save();
      this.login();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new WillPopScope(
      onWillPop: () async => true,
      child: new Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/fragments/top1.png",
                width: size.width * 0.30,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                "assets/images/fragments/bottom1.png",
                width: size.width * 0.4,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                "V 1.0.0 | InnovaTech Ltd.",
                style: TextStyle(fontSize: 12),
              ),
            ),
            SafeArea(
              child: Container(
                  height: size.height,
                  padding:
                      EdgeInsets.only(top: 25, left: 25, bottom: 5, right: 25),
                  child: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Container(
                          child: Column(
                        children: <Widget>[
                          Text(
                            "EasyPerod",
                            style: TextStyle(
                                color: Colors.red.shade900,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Your Period Tracking App",
                            style: TextStyle(fontSize: 18, height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                          Image.asset(
                            "assets/images/empowerment/" +
                                randompicnumber +
                                ".png",
                            height: 150,
                            alignment: Alignment.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Form(
                            key: formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    labelText: "Your Email",
                                    contentPadding: EdgeInsets.all(0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  validator: (value) {
                                    if (value.length == 0) {
                                      return "Please write your email.";
                                    }
                                    if (!RegExp(
                                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                        .hasMatch(value)) {
                                      return "Please provide a valid email address.";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    setState(() {
                                      email = value.trim();
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
                              onPressed: handleSubmit,
                              icon: Icon(Icons.email_outlined),
                              label: Text("Send Reset Password Email"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ))),
            )
          ],
        ),
      ),
    );
  }
}
