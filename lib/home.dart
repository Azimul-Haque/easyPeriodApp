import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoggedIn = false;
  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  var email;
  var password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Codesundar")),
      body: Container(
          child: Column(
        children: <Widget>[
          Container(
              child: Column(
            children: <Widget>[
              TextFormField(
                maxLength: 160,
                decoration: InputDecoration(
                  labelText: "Your Email",
                ),
                validator: (value) {
                  if (value.length == 0) {
                    return "Please write your email.";
                  }
                  return null;
                },
                onChanged: (value) {
                  email = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                maxLength: 160,
                decoration: InputDecoration(
                  labelText: "Your Password",
                ),
                validator: (value) {
                  if (value.length == 0) {
                    return "Please write your password.";
                  }
                  return null;
                },
                onChanged: (value) {
                  password = value;
                },
              ),
            ],
          )),
          Container(
            child: _isLoggedIn
                ? Column(
                    children: [
                      Image.network(_userObj.photoUrl),
                      Text(_userObj.displayName),
                      Text(_userObj.email),
                      TextButton(
                          onPressed: () {
                            _googleSignIn.signOut().then((value) {
                              setState(() {
                                _isLoggedIn = false;
                              });
                            }).catchError((e) {});
                          },
                          child: Text("Logout"))
                    ],
                  )
                : Center(
                    child: ElevatedButton(
                      child: Text("Login with Google"),
                      onPressed: () {
                        _googleSignIn.signIn().then((userData) {
                          setState(() {
                            _isLoggedIn = true;
                            _userObj = userData;
                          });
                        }).catchError((e) {
                          print(e);
                        });
                      },
                    ),
                  ),
          )
        ],
      )),
    );
  }
}
