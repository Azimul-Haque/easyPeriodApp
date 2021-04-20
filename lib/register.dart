import 'dart:math';

import 'package:easyperiod/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easyperiod/globals.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final randompicnumber = (Random().nextInt(7) + 1).toString();
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var name;
  var email;
  var password;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        // User user = FirebaseAuth.instance.currentUser;
        print(user);
        Route route = MaterialPageRoute(builder: (context) => HomePage());
        Navigator.push(context, route);
      }
    });
  }

  Future<dynamic> register() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: const Text('Signed up successfully!'),
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
          behavior: SnackBarBehavior.floating,
          content: (e.code == 'email-already-in-use')
              ? Text("The email address is already in use by another account.")
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

  Future<dynamic> login() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      // User user = firebaseAuth.currentUser;
      // print(user);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: const Text('Logged in!'),
        ),
      );
      // Route route = MaterialPageRoute(builder: (context) => HomePage());
      // Navigator.push(context, route);
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: (e.code == 'user-not-found')
              ? Text("No user found with this email.")
              : (e.code == 'wrong-password')
                  ? Text("Wrong Password!")
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

  Future googlelogin() async {
    showAlertDialog(context, "Connecting with google...");
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
    // print(user);
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Logged in!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Error! Try again.'),
        ),
      );
      Navigator.pop(context);
    }
  }

  void handleSubmit() {
    if (formKey.currentState.validate()) {
      showAlertDialog(context, "Creating new account...");
      FocusScope.of(context).unfocus();
      formKey.currentState.save();
      this.register();
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
                width: size.width * 0.24,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                "assets/images/fragments/bottom1.png",
                width: size.width * 0.34,
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
                      EdgeInsets.only(top: 15, left: 25, bottom: 5, right: 25),
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
                            height: 110,
                            alignment: Alignment.center,
                          ),
                          Text(
                            "Create New Account",
                            style: TextStyle(
                                color: Colors.indigo[900],
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Form(
                            key: formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: nameController,
                                  maxLength: 25,
                                  decoration: InputDecoration(
                                    labelText: "Your Name",
                                    contentPadding: EdgeInsets.all(0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  validator: (value) {
                                    if (value.length == 0) {
                                      return "Please write your name.";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    setState(() {
                                      name = value.trim();
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
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
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    labelText: "Your Password",
                                    contentPadding: EdgeInsets.all(0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    prefixIcon: Icon(Icons.vpn_key),
                                  ),
                                  validator: (value) {
                                    if (value.length == 0) {
                                      return "Please write your password.";
                                    }
                                    if (value.length < 6) {
                                      return "Password should contain atleast 6 characters.";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    setState(() {
                                      password = value.trim();
                                    });
                                  },
                                  obscureText: true,
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
                              icon: Icon(Icons.person_add_alt),
                              label: Text("Register"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Route route = MaterialPageRoute(
                                        builder: (context) => LoginPage());
                                    Navigator.push(context, route);
                                  },
                                  icon: Icon(Icons.login),
                                  label: Text("Sign in"),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blueAccent,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                                width: 10,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: googlelogin,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/fragments/google.png",
                                        height: 20,
                                        alignment: Alignment.center,
                                      ),
                                      Text(" Google Sign In"),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.yellow[800],
                                    onPrimary: Colors.black87,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                              )
                            ],
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
