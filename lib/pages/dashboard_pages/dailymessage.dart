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
  bool banglavisibility = false;
  bool buttonvisibility = true;
  User userdata;

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
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
        height: double.infinity,
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
        child: ListView(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
          shrinkWrap: true,
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              data[0],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: screenwidth - 155,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data[1],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black12,
                          Colors.black12,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                  ),
                  Positioned(
                    height: 80,
                    right: 15,
                    bottom: 15,
                    child: ClipRRect(
                      child: Image.asset("assets/images/dailyicons/sun.png"),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 5,
                  ),
                  width: screenwidth * .35,
                  child: Visibility(
                    visible: buttonvisibility,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          banglavisibility = !banglavisibility;
                          buttonvisibility = !banglavisibility;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.translate,
                            size: 15,
                          ),
                          Text(
                            " Bengali",
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: banglavisibility,
              child: Card(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: screenwidth - 155,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  data[2],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black12,
                            Colors.black12,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                    ),
                    Positioned(
                      height: 80,
                      right: 15,
                      bottom: 15,
                      child: ClipRRect(
                        child: Image.asset("assets/images/dailyicons/sun.png"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 150,
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
