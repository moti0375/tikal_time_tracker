import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tikal_time_tracker/data/dom/dom_parser.dart';
import 'package:tikal_time_tracker/data/repository/app_repository.dart';
import 'package:tikal_time_tracker/pages/login/login_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/firebase_endpoint.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'package:tikal_time_tracker/services/locator/locator.dart';
import 'package:tikal_time_tracker/storage/preferences.dart';

import 'network/time_tracker_api.dart';

void main() async {
  setupLocator();
  Preferences preferences = await initPrefs();
  runApp(Provider<Preferences>(
      create: (_) => preferences, child: new TimeTracker()));
}

Future<Preferences> initPrefs() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return Preferences.init(preferences);
}

class TimeTracker extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FirebaseEndpoint firebaseEndpoint = FirebaseEndpoint();
    Analytics.install(firebaseEndpoint);
    Analytics.init();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BaseAuth>(
            create: (context) => AppAuth(locator<AppRepository>())),
      ],
      child: new MaterialApp(
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
          home: new LoginPage()),
    );
  }
}
