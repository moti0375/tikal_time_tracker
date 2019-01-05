import 'package:flutter/src/material/time.dart';

import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_contract.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_page.dart';

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
    print("commentEntered: $comment");
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
    print("saveButtonClicked");
    _saveTimeRecord();
  }

  @override
  void dateSelected(DateTime date) {
    this.timeRecord.date = date;
    _updateButtonState();
  }

  @override
  void startTimeSelected(TimeOfDay startTime) {
    this.timeRecord.start = startTime;
    _calculateDuration();
    _updateButtonState();
  }

  @override
  void endTimeSelected(TimeOfDay endTime) {
    this.timeRecord.finish = endTime;
    _calculateDuration();
    _updateButtonState();

  }

  void _calculateDuration(){
    if(this.timeRecord.finish != null){
      this.timeRecord.duration = calculateDuration(
          date: DateTime.now(),
          startTime: this.timeRecord.start,
          finishTime: timeRecord.finish);
    }
  }

  @override
  void taskSelected(Task task) {
    this.timeRecord.task = task;
    view.showSelectedTask(this.timeRecord.task);
    _updateButtonState();
  }


  void _saveTimeRecord(){
    if(flow == NewRecordFlow.new_record){
      print("_saveTimeRecord: about to save ${this.timeRecord.toString()}");
      repository.addTime(this.timeRecord).then((response){
        print("Response: $response");
        view.showSaveRecordSuccess(this.timeRecord);
      },onError: (e){
        print("There was an error: ${e.toString()}");
      });
    }

    if(flow == NewRecordFlow.update_record){
      print("_saveTimeRecord: about to update ${this.timeRecord.toString()}");
      repository.updateTime(this.timeRecord).then((response){
        view.showSaveRecordSuccess(this.timeRecord);
      },onError: (e){
        print("There was an error: ${e.toString()}");
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

  @override
  void noteChanged(String note) {
    this.timeRecord.comment = note;
  }

  @override
  void deleteButtonClicked() {
    _handleDeleteButton();
  }

  _handleDeleteButton(){
    print("About to delete record: ${this.timeRecord.toString()}");
    repository.deleteTime(this.timeRecord).then((response){
      print("Success: $response");
      view.showSaveRecordSuccess(this.timeRecord);
    }, onError: (e){
      print("_handleDeleteButton: There was an error");
    });
  }
}

