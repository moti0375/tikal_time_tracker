import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/ui/app_drawer.dart';
import 'package:tikal_time_tracker/ui/time_title.dart';
import 'new_record_page.dart';
import '../data/models.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage> implements DrawerOnClickListener {
  Choice _onSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(title: "Tikal Time Tracker"),
        floatingActionButton:
            new FloatingActionButton(onPressed: () {
              final projects = [
                new Project(name: "Leumi", tasks: [JobTask.Development, JobTask.Consulting]),
                new Project(name: "GM", tasks: [JobTask.Development, JobTask.Consulting]),
                new Project(name: "Tikal", tasks: [JobTask.Development, JobTask.Meeting, JobTask.Training, JobTask.Vacation, JobTask.Accounting, JobTask.ArmyService, JobTask.General, JobTask.Illness, JobTask.Management, JobTask.Meeting])];
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new NewRecordPage(projects: projects)));
            }, child: Icon(Icons.add)),
        body: ListView(
          children: <Widget>[
            new TimePageTitle()
          ],
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

  void _select(Choice choice){
    setState(() {

    });
  }

  AppBar _buildAppBar({String title}) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        PopupMenuButton<Choice>(
          onSelected: _select,
          itemBuilder: (BuildContext context){
            return choices.map((Choice c){
              return PopupMenuItem<Choice>(
                value: c,
                child: Text(c.title),
              );
            }).toList();
          },
        )
      ],
    );
  }
}

class Choice{
  final String title;
  final IconData icon;
  const Choice({this.title, this.icon});
}

const List<Choice> choices = const <Choice>[
  const Choice(title: "Logout", icon:  Icons.transit_enterexit)
];
