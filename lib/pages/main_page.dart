import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/ui/app_drawer.dart';
import 'package:tikal_time_tracker/ui/time_title.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage> implements DrawerOnClickListener {



  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Tikal Time Tracker",
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Scaffold(
        drawer: new AppDrawer(clickListener: this),
        appBar: new AppBar(
          title: new Text("Tikal Time Tracker",
              style: TextStyle(color: Colors.white)),
        ),
        floatingActionButton:
            new FloatingActionButton(onPressed: () {
              print("Add new Time record");
            }, child: Icon(Icons.add)),
        body: ListView(
          children: <Widget>[
            new TimePageTitle()
          ],
        ),
      ),
    );
  }

  @override
  void onLogoutClicked() {
    print("onLogoutClicked");
  }

  @override
  void onProfileClicked() {
    print("onProfileClicked");
  }

  @override
  void onReportClicked() {
    print("onReportClicked");
  }

  @override
  void onTimeClicked() {
    print("onTimeClicked");
  }

  @override
  void onUsersClicked() {
    print("onUsersClicked");
  }
}
