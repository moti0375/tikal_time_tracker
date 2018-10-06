import 'package:flutter/src/material/time.dart';

import '../../data/project.dart';
import '../../data/task.dart';
import '../../data/models.dart';
import '../../data/repository/time_records_repository.dart';
import 'new_record_contract.dart';
import 'new_record_page.dart';

class NewRecordPresenter implements NewRecordPresenterContract {
  static const String  TAG = "NewRecordPresenter";

  NewRecordViewContract view;
  TimeRecord timeRecord;
  TimeRecordsRepository repository;
  NewRecordFlow flow;

  Task _selectedTask;
  List<Task> _tasks = new List<Task>();
  Project _selectedProject;
  bool formOk;


  NewRecordPresenter({this.repository, this.timeRecord, this.flow}) {
    print("$TAG: created");
  }

  @override
  void subscribe(NewRecordViewContract view) {
    this.view = view;
    if (this.timeRecord == null) {
      print("$TAG: subscribe: new record");
      this.timeRecord = TimeRecord.empty();
      view.initNewRecord();
    }else{
      print("$TAG: subscribe: update a record");
      view.initUpdateRecord();
    }
  }

  @override
  void commentEntered(String comment) {
    this.timeRecord.comment = comment;
  }

  @override
  void projectSelected(Project project) {
    this.timeRecord.project = project;
    _selectedProject = project;
    _tasks.clear();
    _tasks.addAll(project.tasks);
    _selectedTask = null;
    view.showSelectedProject(_selectedProject);
    view.showAssignedTasks(_tasks);
    view.showSelectedTask(_selectedTask);
  }

  @override
  void saveButtonClicked() {
    _saveTimeRecord();
  }

  @override
  void dateSelected(DateTime date) {
    this.timeRecord.date = date;
    view.showSelectedDate(this.timeRecord.date);
    _updateButtonState();
  }

  @override
  void startTimeSelected(TimeOfDay startTime) {
    this.timeRecord.start = startTime;
    view.showSelectedStartTime(this.timeRecord.start);
    _updateButtonState();
  }

  @override
  void endTimeSelected(TimeOfDay endTime) {
    this.timeRecord.finish = endTime;
    view.showSelectedFinishTime(this.timeRecord.finish);

    this.timeRecord.duration = calculateDuration(
        date: DateTime.now(),
        startTime: this.timeRecord.start,
        finishTime: timeRecord.finish);
    _updateButtonState();

  }

  @override
  void taskSelected(Task task) {
    this.timeRecord.task = task;
    view.showSelectedTask(this.timeRecord.task);
    _updateButtonState();
  }


  void _saveTimeRecord(){
    print("_saveTimeRecord: about to save ${this.timeRecord.toString()}");
  }

  Duration calculateDuration(
      {DateTime date, TimeOfDay startTime, TimeOfDay finishTime}) {
    DateTime s = new DateTime(
        date.year, date.month, date.day, startTime.hour, startTime.minute);
    DateTime f = new DateTime(
        date.year, date.month, date.day, finishTime.hour, finishTime.minute);

    Duration d = f.difference(s);
    print("${d.inHours}:${d.inSeconds % 60}");
    view.showDuration(d);
    return d;
  }


  _updateButtonState(){
    if (timeRecord.date != null && timeRecord.start != null && timeRecord.project != null && timeRecord.task != null) {
      print("setButtonState: Button enabled");
      formOk = true;
    } else {
      print("setButtonState: Button diabled");
      formOk = false;
    }
    view.setButtonState(formOk);
  }
}

