import 'package:easyperiod/globals.dart';
import 'package:easyperiod/pages/dashboard_pages/insight_pages/webpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';

class Insights extends StatefulWidget {
  final urlcollection;
  Insights(this.urlcollection);
  @override
  _InsightsState createState() => _InsightsState(this.urlcollection);
}

class _InsightsState extends State<Insights> {
  var urlcollection;
  _InsightsState(this.urlcollection);
  User userdata;
  // List urlcollection = [
  //   {'url': 'http://is.gd/W7BRGT'},
  //   {'url': 'http://is.gd/XeNrbZ'},
  //   {'url': 'http://is.gd/F3v1T3'},
  //   {'url': 'http://is.gd/fp5MM8'},
  //   {'url': 'http://is.gd/5U4mYM'},
  //   {'url': 'http://is.gd/3U2jml'},
  // ];
  List datacollected = [];

  @override
  void initState() {
    super.initState();
    urlcollection.forEach((element) {
      datacollected.add(Client().get(Uri.parse(element)));
    });
    userdata = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: AppBar(
        title: Text('Insights'),
        flexibleSpace: appBarStyle(),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(CupertinoIcons.multiply),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: urlcollection.length,
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder(
            future: datacollected[index],
            builder: (context, snapshot) {
              Widget retVal;
              if (snapshot.connectionState == ConnectionState.done) {
                retVal = _buildPreviewWidget(
                    snapshot.data.body, urlcollection[index]);
              } else {
                retVal = Center(
                  // child: CircularProgressIndicator(
                  //   strokeWidth: 1,
                  // ),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: double.maxFinite,
                          height: 200.0,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.white24,
                            child: Container(
                              color: Colors.white12,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          height: 10.0,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.white24,
                            child: Container(
                              color: Colors.white12,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          height: 10.0,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.white24,
                            child: Container(
                              color: Colors.white12,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: screenwidth * .5,
                          height: 10.0,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.white24,
                            child: Container(
                              color: Colors.white12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return retVal;
            },
          );
        },
      ),
    );
  }

  _buildPreviewWidget(document, url) {
    // print(document);
    if (document == null) {
      return Container();
    }

    String description, title, image, appleIcon, favIcon, category;
    document = parse(document);
    var elements = document.getElementsByTagName('meta');
    final linkElements = document.getElementsByTagName('link');

    elements.forEach((tmp) {
      if (tmp.attributes['property'] == 'og:title') {
        title = tmp.attributes['content'];
      }

      if (title == null || title.isEmpty) {
        title = document.getElementsByTagName('title')[0].text;
      }

      if (tmp.attributes['property'] == 'og:description') {
        description = tmp.attributes['content'];
      }
      if (description == null || description.isEmpty) {
        //fetch base title
        if (tmp.attributes['name'] == 'description') {
          description = tmp.attributes['content'];
        }
      }
      if (tmp.attributes['property'] == 'og:category') {
        category = tmp.attributes['content'];
      }

      //fetch image
      if (tmp.attributes['property'] == 'og:image') {
        image = tmp.attributes['content'];
      }
    });

    linkElements.forEach((tmp) {
      if (tmp.attributes['rel'] == 'apple-touch-icon') {
        appleIcon = tmp.attributes['href'];
      }
      if (tmp.attributes['rel']?.contains('icon') == true) {
        favIcon = tmp.attributes['href'];
      }
    });

    var data = {
      'title': title ?? '',
      'description': description ?? '',
      'image': image ??
          'https://tenxorg.com/images/blogs/how-to-manage-your-time-for-achieving-your-goals-1618900206.jpg',
      'category': category ?? '',
      'appleIcon': appleIcon ?? '',
      'favIcon': favIcon ?? '',
      'url': "someurl",
    };

    return Card(
      color: Colors.lightGreen[50],
      elevation: 1.5,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(
                  data['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data['category'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 15),
                      ),
                      Text(
                        data['title'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.white12,
                // splashColor: Colors.red,
                onTap: () {
                  Route route =
                      MaterialPageRoute(builder: (context) => WebPage(url));
                  Navigator.push(context, route);
                },
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
