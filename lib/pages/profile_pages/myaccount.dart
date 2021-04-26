import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easyperiod/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
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

  File _image;

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
                        backgroundImage: _image != null
                            ? FileImage(File(_image.path))
                            : AssetImage("assets/images/user.png"),
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
                              this.showImageUploadDialog();
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
                    child: Image.asset("assets/images/faded/6.png"),
                  ),
                ),
                // Text("Image Size: " + (_image?.lengthSync()).toString()),
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
              (value) => this.showSnackBarandPop("Profile updated."),
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

  showImageUploadDialog() {
    var screenheight = MediaQuery.of(context).size.height;
    AlertDialog alert = AlertDialog(
      title: Center(child: Text('Choose one')),
      content: Container(
        height: screenheight * .2,
        child: Column(
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () => getImage(ImageSource.camera),
              icon: Icon(CupertinoIcons.camera),
              label: Text("Camera"),
            ),
            ElevatedButton.icon(
              onPressed: () => getImage(ImageSource.gallery),
              icon: Icon(CupertinoIcons.photo_fill_on_rectangle_fill),
              label: Text("Gallery"),
            ),
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future getImage(imageSource) async {
    print("Called");
    Navigator.of(context, rootNavigator: true).pop();
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.getImage(source: imageSource);
    File croppedImage = await ImageCropper.cropImage(
        maxWidth: 250,
        maxHeight: 250,
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Edit Image',
            toolbarColor: Colors.red,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        compressQuality: 40);
    setState(() {
      _image = croppedImage;
    });
    if (_image.lengthSync() > 0) {
      this.uploadImage();
    }
    // print("Image File: " + _image.readAsBytesSync().toString());
  }

  uploadImage() async {
    showAlertDialog(context, "Uploading image...");
    var encodedimage = base64Encode(_image.readAsBytesSync());
    // print(base64Decode(encodedimage));

    var data = {
      'uid': userdata.uid,
      'image': encodedimage,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(
          "https://cvcsbd.com/dashboard/easyperiod/store/userimage/api",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        if (body["success"] == true) {
          this.showSnackBarandPop("Image uploaded.");
          // print(body["image"]);
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

  showSnackBarandPop(message) {
    Timer(Duration(seconds: 1), () {
      // userdata.reload();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(message),
        ),
      );
      Navigator.of(context).pop();
    });
  }
}
