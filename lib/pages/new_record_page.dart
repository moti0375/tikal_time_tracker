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
  Project _selectedProject;
  TimeOfDay _startTime;
  TimeOfDay _finishTime;
  TextEditingController startTimeController;
  TextEditingController finishTimeController;

  List<Project> _projects = new List<Project>();

  JobTask _selectedTask;
  List<JobTask> _tasks = new List<JobTask>();

  @override
  void initState() {
    super.initState();
    _projects.addAll(widget.projects);
    _selectedProject = _projects.elementAt(0);
    _tasks.addAll(_selectedProject.tasks);

    _selectedTask = _tasks.elementAt(0);
    startTimeController = new TextEditingController(text: "");
    finishTimeController = new TextEditingController(text: "");
  }

  void _onProjectSelected(Project value) {
    setState(() {
      _selectedProject = value;
      _tasks.clear();
      _tasks.addAll(value.tasks);
      _selectedTask = value.tasks.elementAt(0);
    });
  }

  void _onTaskSelected(JobTask value) {
    setState(() {
      _selectedTask = value;
    });
  }

  void _onPickedStartTime(TimeOfDay startTime) {
    setState(() {
      _startTime = startTime;
    });
  }

  void _onPickedFinishTime(TimeOfDay finishTime) {
    setState(() {
      _startTime = finishTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final projectsDropDown = Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 1,
            child:  new Text(
              "Project: ",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          )
         ,
          Expanded(
            flex: 2,
            child: new DropdownButton(
               isDense: false,
                iconSize: 40.0,
                elevation: 2,
                value: _selectedProject,
                items: _projects.map((Project value) {
                  return new DropdownMenuItem<Project>(
                    value: value,
                    child: new Text(
                      value.name,
                      style: TextStyle(fontSize: 25.0),
                    ),
                  );
                }).toList(),
                onChanged: (Project value) {
                  _onProjectSelected(value);
                }),
          )
        ],
      ),
    );

    final tasksDropDown = Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: new Text(
              "Task: ",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          )
          ,
          new Expanded(
              flex:  2,
              child: new DropdownButton(
                iconSize: 40.0,
                  value: _selectedTask,
                  items: _tasks.map((JobTask value) {
                    return new DropdownMenuItem<JobTask>(
                      value: value,
                      child: new Text(
                        value.toString(),
                        style: TextStyle(fontSize: 25.0),
                      ),
                    );
                  }).toList(),
                  onChanged: (JobTask value) {
                    _onTaskSelected(value);
                  })),
        ],
      ),
    );

    final startTimePicker = Container(
      padding: EdgeInsets.only(left: 32.0, right: 32.0),
      child: new Row(
        children: <Widget>[
          Text(
            "Start: ",
            style: TextStyle(fontSize: 20.0),
          ),
          Container(
            child: new Flexible(
                child: new TextField(
              maxLines: 1,
              controller: startTimeController,
            )),
          ),
          GestureDetector(
            onTap: () {
              _showStartTimeDialog();
            },
            child: Icon(Icons.access_time),
          )
        ],
      ),
    );

    final finishTimePicker = Container(
      padding: EdgeInsets.only(left: 32.0, right: 32.0),
      child: new Row(
        children: <Widget>[
          Text(
            "Finish: ",
            style: TextStyle(fontSize: 20.0),
          ),
          Container(
            child: new Flexible(
                child: new TextField(
                    maxLines: 1, controller: finishTimeController)),
          ),
          GestureDetector(
            onTap: () {
              print("onTap finish");
              _showFinishTimeDialog();
            },
            child: Icon(Icons.access_time),
          )
        ],
      ),
    );

    final durationInput = Container(
      padding: EdgeInsets.only(left: 32.0, right: 32.0),
      child: new Row(
        children: <Widget>[
          Text(
            "Duration: ",
            style: TextStyle(fontSize: 20.0),
          ),
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
          Text(
            "Date: ",
            style: TextStyle(fontSize: 20.0),
          ),
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
        body: Column(
          children: <Widget>[
            new NewRecordTitle(),
            projectsDropDown,
            tasksDropDown,
            startTimePicker,
            finishTimePicker,
            durationInput,
            dateInput,
            Container(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: <Widget>[
                    Text("Note: ", style: TextStyle(fontSize: 20.0)),
                    TextField()
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Future<Null> _showStartTimeDialog() async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        _startTime = picked;
        startTimeController =
            new TextEditingController(text: "${picked.hour}:${picked.minute}");
      });
    }
  }

  Future<Null> _showFinishTimeDialog() async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        _finishTime = picked;
        finishTimeController =
            new TextEditingController(text: "${picked.hour}:${picked.minute}");
      });
    }
  }
}
