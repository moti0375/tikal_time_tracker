import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() => runApp(new TimeTracker());

class TimeTracker extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Time Tracker",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue
      ),
      home: new LoginPage()
    );
  }

}