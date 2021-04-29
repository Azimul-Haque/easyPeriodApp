import 'dart:async';
import 'dart:io';

import 'package:easyperiod/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  final url;
  WebPage(this.url);
  @override
  _WebPageState createState() => _WebPageState(this.url);
}

class _WebPageState extends State<WebPage> {
  var url;
  _WebPageState(this.url);

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool isLoading = true;

  User userdata;

  @override
  void initState() {
    super.initState();
    userdata = FirebaseAuth.instance.currentUser;
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Insights'),
        flexibleSpace: appBarStyle(),
        // automaticallyImplyLeading: false,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              share(this.url, "EasyPeriod Insight Article");
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WebView(
              initialUrl: this.url,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
              javascriptMode: JavascriptMode.unrestricted,
            ),
            isLoading
                ? Container(
                    child: LinearProgressIndicator(),
                  )
                : Stack(),
          ],
        ),
      ),
    );
  }
}
