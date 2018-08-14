import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/ui/app_drawer.dart';
import 'package:tikal_time_tracker/ui/time_title.dart';
import 'new_record_page.dart';
import '../data/models.dart';
import '../data/repository/time_records_repository.dart';
import 'dart:async';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage> implements DrawerOnClickListener {
  Choice _onSelected;
  DateTime _selectedDate;
  TextEditingController dateInputController = new TextEditingController(text: "");


  TimeRecordsRepository repository = TimeRecordsRepository();
  List<TimeRecord> _records;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadRecords(_selectedDate);
    dateInputController = new TextEditingController(text: "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(title: "Tikal Time Tracker"),
        floatingActionButton:
            new FloatingActionButton(onPressed: () {
              _navigateToNextScreen();
            }, child: Icon(Icons.add)),
        body: Container(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
              )
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
      new Project(name: "Tikal", tasks: [JobTask.Development, JobTask.Meeting, JobTask.Training, JobTask.Vacation, JobTask.Accounting, JobTask.ArmyService, JobTask.General, JobTask.Illness, JobTask.Management, JobTask.Meeting])];
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new NewRecordPage(projects: projects)));
  }


  Future<Null> _showDateDialog() async {
    final DateTime picked = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(_selectedDate.year-1, 1),
        lastDate: DateTime(_selectedDate.year, 12));

    if(picked != null && picked != _selectedDate){
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



class Choice{
  final String title;
  final IconData icon;
  const Choice({this.title, this.icon});
}

const List<Choice> choices = const <Choice>[
  const Choice(title: "Logout", icon:  Icons.transit_enterexit)
];
