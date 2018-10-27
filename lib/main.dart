import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/pages/login_page.dart';


void main() {
  runApp(new TimeTracker());
}

class TimeTracker extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Time Tracker",
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        showSemanticsDebugger: false,
        theme: ThemeData(
            primarySwatch: Colors.orange,
            textSelectionColor: Colors.white,
            selectedRowColor: Colors.lightBlueAccent),
        home: new LoginPage());
  }


}
