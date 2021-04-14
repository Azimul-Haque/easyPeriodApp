import 'dart:math';

import 'package:easyperiod/home.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final randompicnumber = (Random().nextInt(7) + 1).toString();
  var name;
  var email;
  var password;

  bool _isLoggedIn = false;
  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        User user = FirebaseAuth.instance.currentUser;
        // print(user);
        Route route = MaterialPageRoute(builder: (context) => HomePage());
        Navigator.push(context, route);
      }
    });
  }

  Future<dynamic> register() async {
    // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    // final User user = (await firebaseAuth.createUserWithEmailAndPassword(
    //         email: email, password: password))
    //     .user;
    // if (user != null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: const Text('Works!'),
    //     ),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: const Text('Error!'),
    //     ),
    //   );
    // }
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Signed up!'),
        ),
      );
      User user = firebaseAuth.currentUser;
      user.updateProfile(displayName: name);
      this.login();
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    }
    return null;
  }

  Future<dynamic> login() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = firebaseAuth.currentUser;
      print(user);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Logged in!'),
        ),
      );
      setState(() {
        _isLoggedIn = true;
      });
      Route route = MaterialPageRoute(builder: (context) => HomePage());
      Navigator.push(context, route);
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    }
    return null;
  }

  Future googlelogin() async {
    final GoogleSignInAccount googleSignInAccount =
        await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    UserCredential result =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User user = result.user;
    print(user);
    setState(() {
      _isLoggedIn = true;
    });
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Worked!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text(_isLoggedIn ? "EasyPeriod (Logged in)" : "Easyperiod")),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
              padding: EdgeInsets.only(top: 20, left: 25, bottom: 5, right: 25),
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
                        "assets/images/empowerment/" + randompicnumber + ".png",
                        height: 200,
                        alignment: Alignment.center,
                      ),
                      // TextFormField(
                      //   maxLength: 160,
                      //   decoration: InputDecoration(
                      //     labelText: "Your Name",
                      //   ),
                      //   validator: (value) {
                      //     if (value.length == 0) {
                      //       return "Please write your name.";
                      //     }
                      //     return null;
                      //   },
                      //   onChanged: (value) {
                      //     setState(() {
                      //       name = value;
                      //     });
                      //   },
                      // ),
                      TextFormField(
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
                            email = value.trim();
                          });
                        },
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      TextFormField(
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
                            password = value.trim();
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: login,
                          child: Text("Sign In"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: register,
                        child: Text("Create Account"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          onPrimary: Colors.white,
                        ),
                      ),

                      ElevatedButton(
                        onPressed: googlelogin,
                        child: Text("Google Sign In"),
                      ),
                    ],
                  )),
                ],
              ))),
        ));
  }
}
