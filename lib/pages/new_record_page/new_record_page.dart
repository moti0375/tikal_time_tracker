import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/ui/new_record_title.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'dart:async';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/utils/utils.dart';
import 'package:tikal_time_tracker/ui/date_picker_widget.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_contract.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_presenter.dart';
import 'package:tikal_time_tracker/ui/time_picker.dart';

// ignore: must_be_immutable
class NewRecordPage extends StatefulWidget {
  List<Project> projects;
  DateTime dateTime;
  TimeRecord timeRecord;

  NewRecordFlow flow;

  NewRecordPage({this.projects, this.dateTime, this.timeRecord, this.flow});

  @override
  State<StatefulWidget> createState() {
    return new NewRecordPageState();
  }
}

class NewRecordPageState extends State<NewRecordPage>
    implements NewRecordViewContract {
  Project _selectedProject;
  TimeOfDay _startTime;
  TimeOfDay _finishTime;
  Duration _duration;
  DateTime _date;
  String _comment;
  TextEditingController startTimeController;
  TextEditingController finishTimeController;
  TextEditingController dateInputController;
  TextEditingController durationInputController;
  TextEditingController commentInputController;
  bool isButtonEnabled = false;
  TimeRecordsRepository repository = new TimeRecordsRepository();
  NewRecordPresenterContract presenter;

  List<Project> _projects = new List<Project>();

  Task _selectedTask;
  List<Task> _tasks = new List<Task>();

  @override
  void initState() {
    super.initState();
    print("initState: flow ${widget.flow}");
    _projects.addAll(widget.projects);
    presenter = NewRecordPresenter(
        repository: repository,
        timeRecord: widget.timeRecord,
        flow: widget.flow);
    presenter.subscribe(this);
  }

  @override
  void showSaveRecordFailed() {
    // TODO: implement showSaveRecordFailed
  }

  @override
  void showSaveRecordSuccess(TimeRecord timeRecord) {
    Navigator.of(context).pop(timeRecord);
  }

  @override
  initNewRecord() {
    print("_initNewRecord:");
    startTimeController = new TextEditingController(
      text: "",
    );
    finishTimeController = new TextEditingController(text: "");
    dateInputController = new TextEditingController(text: "");
    if (widget.dateTime != null) {
      presenter.dateSelected(widget.dateTime);
    }
  }

  @override
  initUpdateRecord() {
    print("_initUpdateRecord:");
    presenter.projectSelected(widget.timeRecord.project);
    presenter.taskSelected(widget.timeRecord.task);
    presenter.dateSelected(widget.timeRecord.date);
    presenter.startTimeSelected(widget.timeRecord.start);
    presenter.endTimeSelected(widget.timeRecord.finish);
    presenter.commentEntered(widget.timeRecord.comment);
    commentInputController = TextEditingController(text: widget.timeRecord.comment);
  }

  @override
  void showSelectedProject(Project value) {
    setState(() {
      print("_onProjectSelected");
      _selectedProject = value;
    });
  }

  @override
  void showAssignedTasks(List<Task> tasks) {
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  void showSelectedTask(Task value) {
    setState(() {
      _selectedTask = value;
    });
  }

  @override
  void showSelectedStartTime(TimeOfDay startTime) {
    setState(() {
      _startTime = startTime;
    });
  }

  @override
  void showSelectedFinishTime(TimeOfDay finishTime) {
    setState(() {
      _finishTime = finishTime;
    });
  }

  @override
  void showDuration(Duration duration) {
    setState(() {
      _duration = duration;
      durationInputController = TextEditingController(
          text: _duration == null ? "" : Utils.buildTimeStringFromDuration(_duration));
    });
  }

  @override
  void setButtonState(bool enabled) {
    setState(() {
      isButtonEnabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final projectsDropDown = Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.black45)),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButtonHideUnderline(
          child: new DropdownButton(
              iconSize: 30.0,
              hint: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Select a Project",
                  style: TextStyle(fontSize: 24.0, color: Colors.black26),
                ),
              ),
              value: _selectedProject,
              items: _projects.map((Project value) {
                return new DropdownMenuItem<Project>(
                  value: value,
                  child: new Text(
                    value.name,
                    style: TextStyle(fontSize: 24.0),
                  ),
                );
              }).toList(),
              onChanged: (Project value) {
                presenter.projectSelected(value);
              }),
        ));

    final tasksDropDown = Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.black45)),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButtonHideUnderline(
          child: new DropdownButton(
              iconSize: 30.0,
              hint: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Select a Task",
                  style: TextStyle(fontSize: 24.0, color: Colors.black26),
                ),
              ),
              value: _selectedTask,
              items: _tasks.map((Task value) {
                return new DropdownMenuItem<Task>(
                  value: value,
                  child: new Text(
                    value.name
                        .toString()
                        .substring(value.toString().indexOf('.') + 1),
                    style: TextStyle(fontSize: 24.0),
                  ),
                );
              }).toList(),
              onChanged: (Task value) {
                presenter.taskSelected(value);
              }),
        ));


    final startTimePicker = TimeTrackerTimePicker(pickedTime: _startTime, hint: "Start Time", callback: (TimeOfDay time){
      presenter.startTimeSelected(time);
    });

    final finishTimePicker = TimeTrackerTimePicker(pickedTime: _finishTime, hint: "Finish Time", callback: (TimeOfDay time){
      presenter.endTimeSelected(time);
    });

    final durationInput = Container(
      padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
      child: new Row(
        children: <Widget>[
          Container(
            child: new Flexible(
                child: new TextField(
                    enabled: false,
                    controller: durationInputController,
                    decoration: InputDecoration(
                        hintText: "Duration",
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    maxLines: 1)),
          ),
        ],
      ),
    );

    final dateInput = Container(
      padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
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
                    decoration: InputDecoration(
                        hintText: "Date",
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    maxLines: 1,
                    controller: dateInputController)),
          ),
        ],
      ),
    );

    Widget datePicker = TimeTrackerDatePicker(dateTime: _date, callback: (date){
      print("datePicker: callback ${date.toString()}");
      setState(() {
        _date = date;
      });
    });

    Widget _saveButton = Padding(
      padding: EdgeInsets.symmetric(
          vertical: 16.0, horizontal: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: isButtonEnabled
            ? Colors.orangeAccent.shade100
            : Colors.grey.shade100,
        elevation: 2.0,
        child: MaterialButton(
          minWidth: 100.0,
          height: 42.0,
          onPressed: () {
            if (isButtonEnabled) {
              presenter.saveButtonClicked();
            }
          },
          color: isButtonEnabled
              ? Colors.orangeAccent
              : Colors.grey,
          child: Text("Save",
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    Widget _deleteButton = Padding(
      padding: EdgeInsets.symmetric(
          vertical: 16.0, horizontal: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Colors.orangeAccent.shade100,
        elevation: 2.0,
        child: MaterialButton(
          minWidth: 100.0,
          height: 42.0,
          onPressed: () {
            presenter.deleteButtonClicked();
          },
          color: Colors.orangeAccent,
          child: Text("Delete", style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    Row _buildButtonsRow(){
      List<Widget> children;
      MainAxisAlignment alignment;
      if(widget.flow == NewRecordFlow.update_record){
        children = [_saveButton, _deleteButton];
        alignment = MainAxisAlignment.spaceBetween;
      }else{
        children =  [_saveButton];
        alignment = MainAxisAlignment.center;
      }

      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: alignment,
        children: children,
      );
    }


    Widget _commentField = Container(
          padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
          child: TextField(
              maxLines: 4,
              onChanged: (value) {
                _comment = value;
                presenter.commentEntered(value);
              },
              controller: commentInputController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(10.0)),
                  contentPadding: EdgeInsets.fromLTRB(
                      10.0, 10.0, 10.0, 10.0),
                  hintText: "Note:")
          )
      );

    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.flow == NewRecordFlow.update_record
            ? "Edit a Record"
            : "New Time Record"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 4,
                child: ListView(
                  children: <Widget>[
                    new NewRecordTitle(),
                    projectsDropDown,
                    tasksDropDown,
                    datePicker,
                    startTimePicker,
                    finishTimePicker,
                    durationInput,
                    _commentField
                  ],
                ),
              ),
              Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                          child: _buildButtonsRow())
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _showStartTimeDialog() async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: _startTime != null ? _startTime : TimeOfDay.now());

    if (picked != null) {
      presenter.startTimeSelected(picked);
    }
  }

  Future<Null> _showDatePicker() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1, 1),
        lastDate: DateTime(DateTime.now().year, 12));
    if (picked != null) {
      presenter.dateSelected(picked);
    }
  }

  @override
  showSelectedDate(DateTime date) {
    setState(() {
      _date = date;
      dateInputController = new TextEditingController(
          text: "${_date.day}/${_date.month}/${_date.year}");
    });
  }

  Future<Null> _showFinishTimeDialog() async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: _finishTime != null ? _finishTime : TimeOfDay.now());

    if (picked != null) {
      presenter.endTimeSelected(picked);
    }
  }

  _createEmptyDropDown() {
    _tasks.add(_selectedTask);
    return _tasks.map((Task item) {
      print("item: $item");
      return new DropdownMenuItem<Task>(
        value: item,
        child: new Text(
          item.name,
          style: TextStyle(fontSize: 25.0),
        ),
      );
    }).toList();
  }
}

enum NewRecordFlow { new_record, update_record }
