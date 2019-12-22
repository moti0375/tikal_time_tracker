import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/time.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/new_record_event.dart';
import 'package:tikal_time_tracker/data/exceptions/failed_login_exception.dart';

import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/repository/app_repository.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_contract.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_page.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_page_event.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';

import 'new_record_state_model.dart';

class NewRecordPageBloc {
  static const String  TAG = "NewRecordPageBloc";

  TimeRecord timeRecord;
  final AppRepository repository;
  NewRecordFlow flow;

  Task _selectedTask;
  List<Task> _tasks = new List<Task>();
  Project _selectedProject;
  Analytics _analytics;
  NewRecordStateModel newRecordPageStateModel;


  NewRecordPageBloc(this._analytics, List<Project> projects, {this.repository, this.timeRecord}) {
    newRecordPageStateModel = NewRecordStateModel(projects: projects);
    print("$TAG: created");
    _analytics.logEvent(NewRecordeEvent.impression(EVENT_NAME.NEW_TIME_PAGE_OPENED).setUser(User.me.name).view());
    initEventStream();
    initBloc(projects);
  }


  StreamController<NewRecordStateModel> _stateController = StreamController.broadcast();

  Stream<NewRecordStateModel> get stateStream => _stateController.stream;
  Sink<NewRecordStateModel> get _stateSink => _stateController.sink;

  StreamController<NewRecordPageEvent> _eventController = StreamController<NewRecordPageEvent>();
  Sink<NewRecordPageEvent> get _eventSink => _eventController.sink;

  void initBloc(List<Project> projects) async {
    print("$TAG initBloc");

    if(timeRecord != null){
      print("$TAG update a recrod");
      newRecordPageStateModel.updateWithTimeRecord(timeRecord);
      _analytics.logEvent(NewRecordeEvent.impression(EVENT_NAME.EDITING_RECORD).setUser(User.me.name).view());
    } else {
      print("$TAG new recrod");
      newRecordPageStateModel.updateWith(projects: projects)
          .updateWith(date: DateTime.now()).updateWith(startTime: TimeOfDay.now());
      _analytics.logEvent(NewRecordeEvent.impression(EVENT_NAME.CREATING_NEW_RECORD).setUser(User.me.name).view());
    }

    Future.delayed(Duration(milliseconds: 500), (){
      _stateSink.add(newRecordPageStateModel);
      print("$TAG initBloc done ${newRecordPageStateModel.projects.toString()}");
    });

  }


  void _projectSelected(Project project) {
    this.newRecordPageStateModel.updateWith(project: project);
    _stateSink.add(this.newRecordPageStateModel);
  }

  void _dateSelected(DateTime date) {
    _stateSink.add(newRecordPageStateModel.updateWith(date: date));
  }

  void _startTimeSelected(TimeOfDay startTime) {
    _stateSink.add(newRecordPageStateModel.updateWith(startTime: startTime));
    if(startTime != null){
      _calculateDuration();
    }
  }

  void _finishTimeSelected(TimeOfDay endTime) {
    _stateSink.add(newRecordPageStateModel.updateWith(finishTime: endTime));
    _calculateDuration();
  }

  void _calculateDuration(){
    if(newRecordPageStateModel.timeRecord.finish != null && newRecordPageStateModel.timeRecord.start != null){
      this.newRecordPageStateModel.updateWith(duration: calculateDuration(
          date: DateTime.now(),
          startTime: newRecordPageStateModel.timeRecord.start,
          finishTime: newRecordPageStateModel.timeRecord.finish));
      _stateSink.add(this.newRecordPageStateModel);
    }
  }

  void _taskSelected(Task task) {
    _stateSink.add(this.newRecordPageStateModel.updateWith(task: task));
  }

  void _saveTimeRecord(BuildContext context){
    if(this.newRecordPageStateModel.flow == NewRecordFlow.new_record){
      print("_saveTimeRecord: about to save ${this.newRecordPageStateModel.timeRecord.toString()}");
      repository.addTime(this.newRecordPageStateModel.timeRecord).then((response){
        debugPrint("Response: $response");
        Navigator.of(context).pop(this.newRecordPageStateModel.timeRecord);
      }, onError: (e){
        print("There was an error: ${(e as AppException).cause}");
//        view.onError(e);
      });
    }

    if(flow == NewRecordFlow.update_record){
      print("_saveTimeRecord: about to update ${this.timeRecord.toString()}");
      repository.updateTime(this.timeRecord).then((response){
//        view.showSaveRecordSuccess(this.timeRecord);
      }, onError: (e){

        print("There was an error: ${(e as AppException).cause}");
//        view.onError(e);
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
//    print("$TAG: Duration: ${d.inHours}:${d.inSeconds % 60}");
//    view.showDuration(d);
    return d;
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
//      view.showSaveRecordSuccess(this.timeRecord);
    }, onError: (e){
      print("_handleDeleteButton: There was an error");
    });
  }

  void initEventStream() {
    _eventController.stream.listen((event){
      _handleInputEvents(event);
    });
  }

  void dispatchEvent(NewRecordPageEvent event){
    _eventSink.add(event);
  }

  void dispose(){
    print("$TAG dispose:");
    _stateController.close();
    _eventController.close();
  }

  void _handleInputEvents(NewRecordPageEvent event) {
    if(event is OnSelectedProject){
      _projectSelected(event.selectedProject);
    }
    
    if(event is OnSelectedTask){
      _taskSelected(event.selectedTask);
    }
    
    if(event is OnDateSelected){
      _dateSelected(event.selectedDate);
    }
    
    if(event is OnStartTime){
      _startTimeSelected(event.selectedTime);
    }

    if(event is OnFinishTime){
      _finishTimeSelected(event.selectedTime);
    }

    if(event is OnSaveButtonClicked){
      print("OnSaveButtonClicked");
      _saveTimeRecord(event.context);
    }
  }
}

