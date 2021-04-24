import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DailyMessage extends StatefulWidget {
  final data;
  DailyMessage(this.data);
  @override
  _DailyMessageState createState() => _DailyMessageState(this.data);
}

class _DailyMessageState extends State<DailyMessage> {
  var data;
  _DailyMessageState(this.data);

  User userdata;

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    // var screenwidth = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: AppBar(
        title: Text('Daily Message'),
        elevation: 0,
        flexibleSpace: appBarStyle(),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(CupertinoIcons.multiply),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.blue[200],
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
          child: Column(
            children: <Widget>[
              Text(data[0]),
              Text(data[1]),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/faded/11.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  appBarStyle() {
    return Ink(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [
            Colors.blue,
            Colors.blue[200],
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
    );
  }
}
