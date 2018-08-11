import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/ui/new_record_title.dart';
import '../data/models.dart';
import 'dart:async';
import '../data/repository/time_records_repository.dart';

// ignore: must_be_immutable
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
  DateTime _date;
  TextEditingController startTimeController;
  TextEditingController finishTimeController;
  TextEditingController dateInputController;
  bool isButtonEnabled = false;
  TimeRecordsRepository repository = new TimeRecordsRepository();


  List<Project> _projects = new List<Project>();

  JobTask _selectedTask;
  List<JobTask> _tasks = new List<JobTask>();

  @override
  void initState() {
    super.initState();
    _projects.addAll(widget.projects);
    startTimeController = new TextEditingController(
      text: "",
    );
    finishTimeController = new TextEditingController(text: "");
    dateInputController = new TextEditingController(text: "");
  }

  void _onProjectSelected(Project value) {
    setState(() {
      _selectedProject = value;
      _tasks.clear();
      _tasks.addAll(value.tasks);
      _selectedTask = null;
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

  void _setButtonState() {
    setState(() {
      if (_date != null && _startTime != null) {
        print("setButtonState: Button enabled");
        isButtonEnabled = true;
      } else {
        print("setButtonState: Button diabled");
        isButtonEnabled = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final projectsDropDown = Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              DropdownButton(
                  hint: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      "Select a Project",
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                  value: _selectedProject,
                  isDense: true,
                  iconSize: 50.0,
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
                  })
            ]));

    final tasksDropDown = Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Expanded(
              child: new DropdownButton(
                  iconSize: 50.0,
                  hint: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Select a Task",
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                  value: _selectedTask,
                  items: _tasks.map((JobTask value) {
                    return new DropdownMenuItem<JobTask>(
                      value: value,
                      child: new Text(
                        value
                            .toString()
                            .substring(value.toString().indexOf('.') + 1),
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

    final srartTimePicker = Container(
      padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 8.0),
      child: new Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                print("onTap start");
                _showStartTimeDialog();
              },
              child: Icon(Icons.access_time),
            ),
          ),
          Container(
            child: new Flexible(
                child: new TextField(
                    decoration: InputDecoration(hintText: "Start",
                        contentPadding: EdgeInsets.fromLTRB(
                            10.0, 10.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    maxLines: 1,
                    controller: startTimeController)),
          ),
        ],
      ),
    );

    final finishTimePicker = Container(
      padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 8.0),
      child: new Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                print("onTap finish");
                _showFinishTimeDialog();
              },
              child: Icon(Icons.access_time),
            ),
          ),
          Container(
            child: new Flexible(
                child: new TextField(
                    decoration: InputDecoration(hintText: "Finish",
                        contentPadding: EdgeInsets.fromLTRB(
                            10.0, 10.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    maxLines: 1,
                    controller: finishTimeController)),
          ),
        ],
      ),
    );

    final durationInput = Container(
      padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 8.0),
      child: new Row(
        children: <Widget>[
          Container(
            child: new Flexible(
                child: new TextField(
                    decoration: InputDecoration(hintText: "Duration",
                        contentPadding: EdgeInsets.fromLTRB(
                            10.0, 10.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    maxLines: 1)),
          ),
        ],
      ),
    );

    final dateInput = Container(
      padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 8.0),
      child: new Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                print("onTap dateInput");
                _showDatePicker();
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
                    maxLines: 1,
                    controller: dateInputController)),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        title: new Text("Edit New Record"),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            new NewRecordTitle(),
            projectsDropDown,
            tasksDropDown,
            dateInput,
            srartTimePicker,
            finishTimePicker,
            durationInput,
            Container(
                padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    TextField(maxLines: 3,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            contentPadding: EdgeInsets.fromLTRB(
                                10.0, 10.0, 10.0, 10.0),
                            hintText: "Note:"))
                  ],
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    shadowColor: isButtonEnabled
                        ? Colors.orangeAccent.shade100
                        : Colors.grey.shade100,
                    elevation: 2.0,
                    child: MaterialButton(
                      minWidth: 200.0,
                      height: 42.0,
                      onPressed: () {
                        if (isButtonEnabled) {
                          _handleSaveButtonClicked();
                        }
                      },
                      color: isButtonEnabled ? Colors.orangeAccent : Colors
                          .grey,
                      child: Text(
                          "Save", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                )
              ],
            )
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
      _setButtonState();
    }
  }

  Future<Null> _showDatePicker() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime
            .now()
            .year - 1, 1),
        lastDate: DateTime(DateTime
            .now()
            .year, 12));

    if (picked != null) {
      setState(() {
        _date = picked;
        dateInputController =
        new TextEditingController(text: "${picked.month}:${picked.year}");
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
        calculateDuration(
            date: DateTime.now(),
            startTime: _startTime,
            finishTime: _finishTime);
      });
    }
  }

  _handleSaveButtonClicked() {
    print("Button Clicked");
    TimeRecord timeRecord = TimeRecord(project: _selectedProject.name, task: _selectedTask.toString()
        .substring(_selectedTask.toString().indexOf('.') + 1), dateTime: _date, start: _startTime, finish: _finishTime, duration: calculateDuration(date: _date, startTime: _startTime, finishTime: _finishTime), comment: "");
    repository.addTimeForDate(timeRecord).then((value) {
      print("Record ${value.id} was added to db");
      Navigator.pop(context);
    });
    }
  }

  Duration calculateDuration(
      {DateTime date, TimeOfDay startTime, TimeOfDay finishTime}) {
    DateTime s = new DateTime(
        date.year, date.month, date.day, startTime.hour, startTime.minute);
    DateTime f = new DateTime(
        date.year, date.month, date.day, finishTime.hour, finishTime.minute);

    Duration d = f.difference(s);
    print("${d.inHours}:${d.inHours % 60}");
    return d;
  }


