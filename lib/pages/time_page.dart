import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/ui/app_drawer.dart';
import 'package:tikal_time_tracker/ui/time_title.dart';
import 'new_record_page.dart';
import '../data/models.dart';
import '../data/repository/time_records_repository.dart';
import 'dart:async';
import '../pages/login_page.dart';
import 'dart:async';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage> implements DrawerOnClickListener {
  final _items = <String>["Moti", "Nurint", "Yarden", "Yahel"];
  Choice _onSelected;
  DateTime _selectedDate;
  TextEditingController dateInputController = new TextEditingController(text: "");


  TimeRecordsRepository repository = TimeRecordsRepository();
  List<TimeRecord> _records;

  @override
  void initState() {
    super.initState();
    print("initState");
    _selectedDate = DateTime.now();
    _loadRecords(_selectedDate);
    dateInputController = new TextEditingController(text: "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
        appBar: _buildAppBar(title: "Tikal Time Tracker"),
        floatingActionButton:
            new FloatingActionButton(onPressed: () {
              _navigateToNextScreen();
            }, child: Icon(Icons.add)),
        body: Container(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _setDatePicker(),
              Container(
                height: 1.5,
                color: Colors.black26,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 2.0),
                child: Text("Moti Bartov, User, Tikal"),
              ),
              Expanded(
                child: _buildListView(_records),
              )
            ],
          ),
        ),
      );
  }

  Widget _buildListRow(TimeRecord timeRecord ){
    print("_buildListRow: task = ${timeRecord}");
    return new Card(elevation: 1.0,
        margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
                        child: Text(timeRecord.project, style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold))
                    ),
                    SizedBox(width: 2.0),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
                        child: Text(timeRecord.task, style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold))
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
                        child: Text("${timeRecord.dateTime.day}/${timeRecord.dateTime.month}/${timeRecord.dateTime.year}", style: TextStyle(fontSize: 12.0))
                    ),
                    SizedBox(width: 2.0),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                        child: Text("${timeRecord.start.hour}:${timeRecord.start.minute}", style: TextStyle(fontSize: 12.0))
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                        child: Text("-", style: TextStyle(fontSize: 12.0))
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                        child: Text("${timeRecord.finish.hour}:${timeRecord.finish.minute}", style: TextStyle(fontSize: 12.0))
                    ),
                    SizedBox(width: 2.0),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
                        child: Text(",", style: TextStyle(fontSize: 12.0))
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                        child: Text(timeRecord.getDurationString(), style: TextStyle(fontSize: 12.0))
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildListView(List<TimeRecord> items ){
    print("_buildListView");
    return ListView.builder(itemBuilder: (context, i) {
      return _buildListRow(items[i]);
    }, shrinkWrap: true, itemCount: items == null ? 0 : items.length);
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
      if(choice.action == Action.Logout ){
        Navigator.of(context).
        pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new LoginPage()));
      }
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


  Widget _setDatePicker(){
    return  Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: new Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                print("onTap dateInput");
                _showDateDialog();
              },
              child: Icon(Icons.date_range),
            ),
          ),
          Container(
            child: new Flexible(
                child: new TextField(
                    decoration: InputDecoration(hintText: "Date",
                        contentPadding: EdgeInsets.fromLTRB(
                            10.0, 10.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    controller: dateInputController,
                    maxLines: 1)),
          ),
        ],
      ),
    );
  }

  _navigateToNextScreen(){
    final projects = [
      new Project(name: "Leumi", tasks: [JobTask.Development, JobTask.Consulting]),
      new Project(name: "GM", tasks: [JobTask.Development, JobTask.Consulting]),
      new Project(name: "Tikal", tasks: [JobTask.Development, JobTask.Meeting, JobTask.Training, JobTask.Vacation, JobTask.Accounting, JobTask.ArmyService, JobTask.General, JobTask.Illness, JobTask.Management])];
      Navigator.of(context).
      push(new MaterialPageRoute(builder: (BuildContext context) => new NewRecordPage(projects: projects))).then((value){
        if(value != null){
          print("go value from page");
          _loadRecords(_selectedDate);
        }
      });
  }

  Future<Null> _showDateDialog() async {
    final DateTime picked = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(_selectedDate.year-1, 1),
        lastDate: DateTime(_selectedDate.year, 12));

    if(picked != null){
      setState(() {
        _selectedDate = picked;
        dateInputController = new TextEditingController(text: "${picked.day}/${picked.month}/${picked.year}");
        _loadRecords(picked);
      });
    }
  }

  void _loadRecords(DateTime selectedDate) {
    repository.getAllTimeForDate(_selectedDate).then((records) {
      print(records.toString());
      _refreshList(records);
    });
  }

  void _refreshList(List<TimeRecord> records){
    setState(() {
      print("records for ${_selectedDate} : ${records.toString()}");
      _records = records;
    });
  }
}

enum Action{
  Logout,
  Close
}

class Choice{
  final Action action;
  final String title;
  final IconData icon;
  const Choice({this.action, this.title, this.icon});
}

const List<Choice> choices = const <Choice>[
  const Choice(action : Action.Logout, title: "Logout", icon:  Icons.transit_enterexit)
];
