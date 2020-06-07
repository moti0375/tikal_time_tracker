import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/material/time.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/new_record_event.dart';
import 'package:tikal_time_tracker/analytics/events/time_event.dart' as timeEvent;
import 'package:tikal_time_tracker/data/exceptions/failed_login_exception.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/remote.dart';
import 'package:tikal_time_tracker/data/repository/app_repository.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_page.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_page_event.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/ui/platform_alert_dialog.dart';

import 'new_record_state_model.dart';

class NewRecordPageBloc {
  static const String TAG = "NewRecordPageBloc";

  final AppRepository repository;
  final BaseAuth auth;
  NewRecordFlow flow;

  Analytics _analytics;
  NewRecordStateModel newRecordPageStateModel;

  NewRecordPageBloc(this._analytics, List<Project> projects,
      TimeRecord timeRecord, DateTime date,
      {this.auth, this.repository}) {
    newRecordPageStateModel = NewRecordStateModel(projects: projects);
    print("$TAG: created");
    _analytics.logEvent(
        NewRecordEvent.impression(EVENT_NAME.NEW_TIME_PAGE_OPENED).view());
    initEventStream();
    initBloc(projects, timeRecord, date);
  }

  StreamController<NewRecordStateModel> _stateController = StreamController();

  Stream<NewRecordStateModel> get stateStream => _stateController.stream;

  Sink<NewRecordStateModel> get _stateSink => _stateController.sink;

  StreamController<NewRecordPageEvent> _eventController =
      StreamController<NewRecordPageEvent>();

  Sink<NewRecordPageEvent> get _eventSink => _eventController.sink;

  void initBloc(
      List<Project> projects, TimeRecord timeRecord, DateTime dateTime) async {
    print("$TAG initBloc");

    if (timeRecord != null) {
      print("$TAG update a recrod");
      newRecordPageStateModel.updateWithTimeRecord(timeRecord);
      _analytics.logEvent(NewRecordEvent.impression(EVENT_NAME.EDITING_RECORD)
          .view());
    } else {
      print("$TAG new recrod");
      newRecordPageStateModel
          .updateWith(projects: projects)
          .updateWith(date: dateTime);
      _analytics.logEvent(
          NewRecordEvent.impression(EVENT_NAME.CREATING_NEW_RECORD)
              .view());
    }
    _stateSink.add(newRecordPageStateModel);
  }

  void _remoteSelected(Remote remote) {
    this.newRecordPageStateModel.updateWith(remote: remote);
    _stateSink.add(this.newRecordPageStateModel);
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
    if (startTime != null) {
      _calculateDuration();
    }
  }

  void _finishTimeSelected(TimeOfDay endTime) {
    _stateSink.add(newRecordPageStateModel.updateWith(finishTime: endTime));
    _calculateDuration();
  }

  void _calculateDuration() {
    if (newRecordPageStateModel.timeRecord.finish != null &&
        newRecordPageStateModel.timeRecord.start != null) {
      var date = newRecordPageStateModel.timeRecord.date;
      var startTime = newRecordPageStateModel.timeRecord.start;
      var finishTime = newRecordPageStateModel.timeRecord.finish;
      DateTime s = new DateTime(
          date.year, date.month, date.day, startTime.hour, startTime.minute);
      DateTime f = new DateTime(
          date.year, date.month, date.day, finishTime.hour, finishTime.minute);

      Duration d = f.difference(s);

      this.newRecordPageStateModel.updateWith(duration: d);
      _stateSink.add(this.newRecordPageStateModel);
    }
  }

  void _taskSelected(Task task) {
    _stateSink.add(this.newRecordPageStateModel.updateWith(task: task));
  }

  void _saveTimeRecord(BuildContext context) {
    print("_saveTimeRecord: flow ${this.newRecordPageStateModel.flow}");

    if (this.newRecordPageStateModel.flow == NewRecordFlow.new_record) {
      repository.addTime(this.newRecordPageStateModel.timeRecord).then(
        (_) {
          _analytics.logEvent(
              NewRecordEvent.impression(EVENT_NAME.RECORD_SAVED_SUCCESS)
                  .setUser(auth.getCurrentUser().name)
                  .view());
          _popBack(context, this.newRecordPageStateModel.timeRecord);
        },
        onError: (e) {
          _sendFailedEvent(e);
          if (e is IncompleteRecordException) {
            print("_saveTimeRecord: IncompleteRecordException ${e.recordId}");
            _getIncompleteRecordById(e, context);
          } else {
            _showErrorDialog(e, context, "Save Record Error");
          }
        },
      );
    }

    if (this.newRecordPageStateModel.flow == NewRecordFlow.update_record) {
      print(
          "_saveTimeRecord: about to update ${this.newRecordPageStateModel.timeRecord.toString()}");
      repository.updateTime(this.newRecordPageStateModel.timeRecord).then((_) {
        _analytics.logEvent(
            NewRecordEvent.impression(EVENT_NAME.EDIT_RECORD_SUCCESS)
                .setUser(auth.getCurrentUser().name)
                .view());
        _popBack(context, this.newRecordPageStateModel.timeRecord);
      }, onError: (e) {
        _sendFailedEvent(e);
        _showErrorDialog(e, context, "Edit Record Error");
      });
    }
  }

  void _addComment(String note) {
    this.newRecordPageStateModel.updateWith(comment: note);
  }

  _handleDeleteButton(BuildContext context) {
    print("About to delete record: ${this.newRecordPageStateModel.timeRecord.toString()}");
    repository.deleteTime(this.newRecordPageStateModel.timeRecord).then(
          (response) => _popBack(context, this.newRecordPageStateModel.timeRecord),
          onError: (e) => _handleDeleteError);
  }

  void initEventStream() {
    _eventController.stream.listen((event) {
      _handleInputEvents(event);
    });
  }

  void dispatchEvent(NewRecordPageEvent event) {
    _eventSink.add(event);
  }

  void dispose() {
    print("$TAG dispose:");
    _stateController.close();
    _eventController.close();
  }

  void _handleInputEvents(NewRecordPageEvent event) {

    if (event is OnSelectedRemote) {
      _remoteSelected(event.selectedRemote);
    }

    if (event is OnSelectedProject) {
      _projectSelected(event.selectedProject);
    }

    if (event is OnSelectedTask) {
      _taskSelected(event.selectedTask);
    }

    if (event is OnDateSelected) {
      _dateSelected(event.selectedDate);
    }

    if (event is OnStartTime) {
      _startTimeSelected(event.selectedTime);
    }

    if (event is OnFinishTime) {
      _finishTimeSelected(event.selectedTime);
    }

    if (event is OnSaveButtonClicked) {
      _analytics.logEvent(NewRecordEvent.click(EVENT_NAME.SAVE_RECORD_CLICKED));
      _saveTimeRecord(event.context);
    }

    if (event is OnComment) {
      print("OnComment");
      _addComment(event.comment);
    }

    if (event is OnDeleteButtonClicked) {
      _analytics.logEvent(NewRecordEvent.click(EVENT_NAME.DELETE_RECORD_CLICKED));
      _handleDeleteButton(event.context);
    }

    if (event is OnNowButtonClicked) {
      _analytics.logEvent(timeEvent.TimeEvent.click(timeEvent.EVENT_NAME.TIME_PICKER_NOW));
    }
  }

  void _popBack(BuildContext context, TimeRecord timeRecord) {
    Navigator.of(context).pop(this.newRecordPageStateModel.timeRecord);
  }

  void _showErrorDialog(e, context, title) {
    PlatformAlertDialog dialog = PlatformAlertDialog(
        title: title,
        content: e is AppException ? e.cause : "There was an error",
        defaultActionText: "OK",
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Strings.ok),
          ),
        ]);
    dialog.show(context);
  }

  void _getIncompleteRecordById(
      IncompleteRecordException e, BuildContext context) async {
    repository.getIncompleteRecordById(e.recordId).then((response) {
      print("_getIncompleteRecordById: Response: $response");
      _showIncompleteRecordErrorDialog(e, response, context);
    }, onError: (e) => _showErrorDialog(e, context, "Save Record Error"));
  }

  void _showIncompleteRecordErrorDialog(
      IncompleteRecordException e, DateTime recordDate, BuildContext context) {
    print("_showIncompleteRecordErrorDialog: ${e.cause}");

    PlatformAlertDialog dialog = PlatformAlertDialog(
        title: "Save Record Error",
        content: e.cause != null
            ? "${e.cause}.\n Record Date: ${recordDate.day}-${recordDate.month}-${recordDate.year}"
            : "There was an error",
        defaultActionText: "OK",
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context); //Dismiss the popup
              Navigator.of(context).pop(recordDate); //Pop the page
            },
            child: Text("Edit"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context), //Dismiss the popup
            child: Text(Strings.cancel),
          ),
        ]);
    dialog.show(context);
  }

  void _sendFailedEvent(Exception e) {
    var event = NewRecordEvent.impression(EVENT_NAME.FAILED_TO_EDIT_OR_SAVE)
        .setUser(auth.getCurrentUser().name);
    if (e is AppException && e.cause != null) {
      event.setDetails(e.cause).view();
    } else {
      event.setDetails(e.toString()).view();
    }
    _analytics.logEvent(event);
  }

  void _handleDeleteError(Exception e){
    _analytics.logEvent(NewRecordEvent.click(EVENT_NAME.FAILED_TO_DELETE_RECORD).setUser(auth.getCurrentUser().name).setDetails(e.toString()));
  }
}
