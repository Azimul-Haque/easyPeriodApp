import 'dart:async';

import 'package:easyperiod/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePass extends StatefulWidget {
  ChangePass({Key key}) : super(key: key);
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  var formKey = GlobalKey<FormState>();
  var passController = TextEditingController();
  var confirmController = TextEditingController();
  var password;
  var confirm;
  User userdata;

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
          title: Text('Change Password'),
          flexibleSpace: appBarStyle(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
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
                        controller: passController,
                        decoration: InputDecoration(
                          labelText: "New Password",
                          prefixIcon: Icon(CupertinoIcons.lock_shield),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value.length == 0) {
                            return "Please write a password.";
                          }
                          if (value.length < 6) {
                            return "Length must be at least 6 characters.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            this.password = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: confirmController,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          prefixIcon: Icon(CupertinoIcons.lock_shield),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value.length == 0) {
                            return "Please write a password.";
                          }
                          if (value != passController.text) {
                            print(this.passController.text);
                            return "Password does not match.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            this.confirm = value;
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
                    onPressed: updatePassword,
                    icon: Icon(CupertinoIcons.lock),
                    label: Text("Update Password"),
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
                    child: Image.asset("assets/images/faded/5.png"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updatePassword() {
    if (formKey.currentState.validate()) {
      showAlertDialog(context, "Updating...");
      FocusScope.of(context).unfocus();
      formKey.currentState.save();

      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      User currentUser = firebaseAuth.currentUser;

      currentUser.updatePassword(password).then((_) {
        this.showSnackBarandPop();
      }).catchError((error) {
        print(error.code);
        if (error.code == "requires-recent-login") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(error.message),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Error! Try again."),
            ),
          );
        }
        Navigator.of(context).pop();
      });
    }
  }

  showSnackBarandPop() {
    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Password updated."),
        ),
      );
      Navigator.of(context).pop();
    });
  }
}
