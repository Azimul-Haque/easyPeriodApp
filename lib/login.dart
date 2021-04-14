import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        print(user);
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
      body: Container(
          padding: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: Column(
                children: <Widget>[
                  Text("test"),
                  Text("test"),
                  Text("test"),
                  Text("test"),
                  TextFormField(
                    maxLength: 160,
                    decoration: InputDecoration(
                      labelText: "Your Name",
                    ),
                    validator: (value) {
                      if (value.length == 0) {
                        return "Please write your name.";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
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
                  ElevatedButton(
                    onPressed: googlelogin,
                    child: Text("Google Sign In"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      setState(() {
                        _isLoggedIn = false;
                      });
                    },
                    child: Text("Sign Out"),
                  ),
                ],
              )),
              // Container(
              //   child: _isLoggedIn
              //       ? Column(
              //           children: [
              //             // Image.network(_userObj.photoUrl),
              //             // Text(_userObj.displayName),
              //             // Text(_userObj.email),
              //             TextButton(
              //                 onPressed: () {
              //                   _googleSignIn.signOut().then((value) {
              //                     setState(() {
              //                       _isLoggedIn = false;
              //                     });
              //                   }).catchError((e) {});
              //                 },
              //                 child: Text("Logout"))
              //           ],
              //         )
              //       : Center(
              //           child: ElevatedButton(
              //             child: Text("Login with Google"),
              //             onPressed: () {
              //               _googleSignIn.signIn().then((userData) {
              //                 setState(() {
              //                   _isLoggedIn = true;
              //                   _userObj = userData;
              //                 });
              //               }).catchError((e) {
              //                 print(e);
              //               });
              //             },
              //           ),
              //         ),
              // )
            ],
          )),
    );
  }
}
