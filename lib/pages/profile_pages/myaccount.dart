import 'dart:async';
import 'dart:io';

import 'package:easyperiod/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  MyAccount({Key key}) : super(key: key);
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var formname;
  User userdata;

  PickedFile _image;
  Future getImage() async {
    print("Called");
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
    nameController.text = userdata.displayName;
    emailController.text = userdata.email;
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return new WillPopScope(
      onWillPop: () async => true,
      child: new Scaffold(
        appBar: AppBar(
          title: Text('My Account'),
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
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                    fit: StackFit.expand,
                    // overflow: Overflow.visible,
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/user.png"),
                      ),
                      Positioned(
                        right: -16,
                        bottom: 0,
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.grey,
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              this.getImage();
                              print(_image);
                            },
                            child: Icon(Icons.camera_alt_outlined),
                          ),
                        ),
                      )
                    ],
                  ),
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
                        decoration: InputDecoration(
                          labelText: "Your Name",
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
                            this.formname = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        readOnly: true,
                        showCursor: false,
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
                    onPressed: updateAccount,
                    icon: Icon(CupertinoIcons.person),
                    label: Text("Update Profile"),
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
                    child: _image != null
                        ? Image.file(File(_image.path))
                        : Image.asset("assets/images/faded/6.png"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateAccount() {
    if (formKey.currentState.validate()) {
      showAlertDialog(context, "Updating...");
      FocusScope.of(context).unfocus();
      formKey.currentState.save();
      print(formname);
      // print(end);

      try {
        userdata.updateProfile(displayName: formname).then(
              (value) => this.showSnackBarandPop(),
            );
      } on FirebaseAuthException catch (e) {
        print('Failed with error code: ${e.code}');
        print(e.message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Error! Try again."),
            // content: Text(e.message),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  showSnackBarandPop() {
    Timer(Duration(seconds: 1), () {
      // userdata.reload();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Profile updated."),
        ),
      );
      Navigator.of(context).pop();
    });
  }
}
