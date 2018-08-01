import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/ui/new_record_title.dart';
import '../data/models.dart';
import 'dart:async';

class NewRecordPage extends StatefulWidget {
  List<Project> projects;

  NewRecordPage({this.projects});

  @override
  State<StatefulWidget> createState() {
    return new NewRecordPageState();
  }
}

class NewRecordPageState extends State<NewRecordPage> {
  String _selectedProject;
  TimeOfDay _startTime;
  TimeOfDay _finishTime;
  TextEditingController startTimeController;
  TextEditingController finishTimeController;

  List<String> _projects = new List<String>();

  String _selectedTask;
  List<String> _tasks = new List<String>();

  @override
  void initState() {
    super.initState();
    _projects.addAll(["Leumi", "GM", "Tikal"]);
    _selectedProject = _projects.elementAt(0);

    _tasks.addAll(["Development", "Meeting", "Vacation"]);
    _selectedTask = _tasks.elementAt(0);
    startTimeController = new TextEditingController(text: "");
    finishTimeController = new TextEditingController(text: "");
  }

  void _onProjectSelected(String value) {
    setState(() {
      _selectedProject = value;
    });
  }

  void _onTaskSelected(String value) {
    setState(() {
      _selectedTask = value;
    });
  }


  void _onPickedStartTime(TimeOfDay startTime){
    setState(() {
      _startTime = startTime;
    });
  }

  void _onPickedFinishTime(TimeOfDay finishTime){
    setState(() {
      _startTime = finishTime;
    });
  }
  @override
  Widget build(BuildContext context) {
    final projectsDropDown = Container(
      padding: EdgeInsets.only(left: 32.0),
      child: Row(
        children: <Widget>[
          new Text(
            "Project: ",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          new Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: new DropdownButton(
                  value: _selectedProject,
                  items: _projects.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    _onProjectSelected(value);
                  }))
        ],
      ),
    );

    final tasksDropDown = Container(
      padding: EdgeInsets.only(left: 32.0),
      child: Row(
        children: <Widget>[
          new Text(
            "Task: ",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          new Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: new DropdownButton(
                  value: _selectedTask,
                  items: _tasks.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    _onTaskSelected(value);
                  })
          ),
        ],
      ),
    );

    final startTimePicker = Container(
      padding: EdgeInsets.only(left: 32.0, right: 32.0),
      child: new Row(
        children: <Widget>[
          Text("Start: ", style: TextStyle(fontSize: 20.0),),
          Container(
            child: new Flexible(child: new TextField(maxLines: 1, controller: startTimeController,)),
          ),
          GestureDetector(
            onTap: () {_showStartTimeDialog();},
            child: Icon(Icons.access_time),
          )
        ],
      ),
    );

    final finishTimePicker = Container(
      padding: EdgeInsets.only(left: 32.0, right: 32.0),
      child: new Row(
        children: <Widget>[
          Text("Finish: ", style: TextStyle(fontSize: 20.0),),
          Container(
            child: new Flexible(child: new TextField(maxLines: 1, controller: finishTimeController)),
          ),
          GestureDetector(
            onTap: () {_showFinishTimeDialog();},
            child: Icon(Icons.access_time),
          )
        ],
      ),
    );

    final durationInput = Container(
      padding: EdgeInsets.only(left: 32.0, right: 32.0),
      child: new Row(
        children: <Widget>[
          Text("Duration: ", style: TextStyle(fontSize: 20.0),),
          Container(
            child: new Flexible(child: new TextField(maxLines: 1)),
          ),
        ],
      ),
    );

    final dateInput = Container(
      padding: EdgeInsets.only(left: 32.0, right: 32.0),
      child: new Row(
        children: <Widget>[
          Text("Date: ", style: TextStyle(fontSize: 20.0),),
          Container(
            child: new Flexible(child: new TextField(maxLines: 1)),
          ),
          GestureDetector(
            onTap: () {},
            child: Icon(Icons.date_range),
          )
        ],
      ),
    );

    return new MaterialApp(
      title: "Tikal Time Tracker",
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Scaffold(
        appBar: new AppBar(
          title: new Text("Tikal Time Tracker",
              style: TextStyle(color: Colors.white)),
        ),
        body: ListView(
          children: <Widget>[
            new NewRecordTitle(),
            projectsDropDown,
            tasksDropDown,
            startTimePicker,
            finishTimePicker,
            durationInput,
            dateInput,
            Container(
              padding: EdgeInsets.only(left: 32.0, right: 32.0),
                child:Text("Note: ", style: TextStyle(fontSize: 20.0))
            )
          ],
        ),
      ),
    );
  }

  Future<Null> _showStartTimeDialog() async {
    final TimeOfDay picked = await showTimePicker(context: context,
    initialTime: TimeOfDay.now());

    if(picked != null){
      setState(() {
        _startTime = picked;
        startTimeController = new TextEditingController(text: "${picked.hour}:${picked.minute}");
      });
    }
  }

  Future<Null> _showFinishTimeDialog() async {
    final TimeOfDay picked = await showTimePicker(context: context,
        initialTime: TimeOfDay.now());

    if(picked != null){
      setState(() {
        _finishTime = picked;
        finishTimeController = new TextEditingController(text: "${picked.hour}:${picked.minute}");
      });
    }
  }
}
