import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var email;
  var password;

  Future<dynamic> register() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final User user = (await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print("Works");
    } else {
      print("Error");
    }
    return null;
  }

  Future<dynamic> login() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final User user = (await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print("Logged In!");
    } else {
      print("Not a user!");
    }
    return null;
  }

  bool _isLoggedIn = false;
  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();

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
                  setState(() {
                    email = value;
                  });
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
                  setState(() {
                    password = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: register,
                child: Text("Sign Up"),
              ),
              ElevatedButton(
                onPressed: login,
                child: Text("Sign In"),
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
