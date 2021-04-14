library easyperiod.globals;

import 'package:flutter/material.dart';

String userName;
String userDesig;
String userOrg;

appBarStyle() {
  return Ink(
    decoration: new BoxDecoration(
      gradient: new LinearGradient(
        colors: [
          Colors.red[800],
          Colors.red[600],
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp,
      ),
    ),
  );
}
