import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/pages/login_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/firebase_endpoint.dart';


void main() {
  runApp(new TimeTracker());
}

class TimeTracker extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FirebaseEndpoint firebaseEndpoint = FirebaseEndpoint();
    Analytics.install(firebaseEndpoint);
    Analytics.init();
    return new MaterialApp(
        title: "Time Tracker",
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        showSemanticsDebugger: false,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: new FirebaseAnalytics())
        ],
        theme: ThemeData(
            primarySwatch: Colors.orange,
            textSelectionColor: Colors.white,
            selectedRowColor: Colors.lightBlueAccent),
        home: new LoginPage());
  }


}
