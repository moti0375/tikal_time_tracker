import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/time_page.dart';
import 'data/user.dart';

void main() => runApp(new TimeTracker());

class TimeTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Time Tracker",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.orange,
            textSelectionColor: Colors.white,
            selectedRowColor: Colors.lightBlueAccent),
        home: new LoginPage());
  }
}
