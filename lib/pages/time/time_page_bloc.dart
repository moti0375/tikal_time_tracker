import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/new_record_event.dart' as prefix0;
import 'package:tikal_time_tracker/analytics/events/time_event.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/repository/app_repository.dart';
import 'package:tikal_time_tracker/pages/about_screen/about_screen.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_page.dart';
import 'package:tikal_time_tracker/pages/time/time_page_event.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/utils/page_transition.dart';


class TimePageBloc  {

  AppRepository _repository;
  DateTime _currentDate = DateTime.now();
  DateTime get selectedDate => _currentDate;
  BaseAuth _auth;
  Analytics _analytics;

  TimePageBloc(this._repository, this._auth, this._analytics){
   _initializeEventsStream();
   _analytics.logEvent(TimeEvent.impression(EVENT_NAME.TIME_PAGE_OPENED)
       .setUser(_auth.getCurrentUser().name)
       .view());
  }

  StreamController<TimeReport> _timeStreamController = StreamController.broadcast();
  Stream<TimeReport> get timeReportStream => _timeStreamController.stream.asBroadcastStream();
  Sink<TimeReport> get _timeControllerSink => _timeStreamController.sink;

  StreamController<TimePageEvent> _timeEventsController = StreamController<TimePageEvent>();
  Sink<TimePageEvent> get _blocEventsSink => _timeEventsController.sink;


  void dispatchEvent(TimePageEvent event){
    _blocEventsSink.add(event);
  }
  
  
  Future<void> _loadTime(DateTime date) async {
    print("_loadTime: $date");
    _repository.getAllTimeForDate(date).then((records) {
      _timeControllerSink.add(records);
    }, onError: (e){
      print("_loadTime: TimePageBloc There was an error: $e");
      _timeStreamController.addError(e);
    });
  }

  void dispose(){
    print("TimePageBloc: dispose");
    _timeStreamController.close();
    _timeEventsController.close();
  }

  void onItemDismissed(TimeRecord item) {
    print("onItemDismissed: ${item.toString()}");
    _repository.deleteTime(item).then((value){
      print("onItemDismissed: ");
      _loadTime(_currentDate);
    });
  }

  void _initializeEventsStream() {
    _timeEventsController.stream.listen((event) {
      _handleInputEvents(event);
    });
  }
  _navigateToEditScreen(TimeRecord timeRecord, BuildContext context) {
    print("_navigateToEditScreen: projects ${_auth.getCurrentUser().projects}");
    final projects = _auth.getCurrentUser().projects;

    var newRecordPage = NewRecordPage.create(projects, timeRecord, null);
    Navigator.of(context)
        .push(new PageTransition(
        widget: newRecordPage))
        .then((value) {
//      print("got value from page");
      if (value != null) {
        if (value is TimeRecord) {
          dispatchEvent(DateSelectedEvent(selectedDate: value.date));
        }
      } else {
        dispatchEvent(DateSelectedEvent(selectedDate: timeRecord.date));
      }
    });
  }

  _navigateToNextScreen(BuildContext context) {
    final projects = _auth.getCurrentUser().projects;
    print("_navigateToNextScreen: " + projects.toString());

    var newRecordPage = NewRecordPage.create(projects, null, selectedDate);

    Navigator.of(context)
        .push(new PageTransition(
        widget: newRecordPage))
        .then((value) {
//      print("got value from page");
      if (value != null) {
        if (value is TimeRecord) {
          dispatchEvent(DateSelectedEvent(selectedDate: value.date));
        }
        if(value is DateTime){
          print("_navigateToNextScreen: $value");
          dispatchEvent(DateSelectedEvent(selectedDate: value));
        }
      } else {
        dispatchEvent(DateSelectedEvent(selectedDate: selectedDate));
      }
    });
  }

  void _logout() async {
    await _auth.logout();
  }

  void _onAboutClicked(BuildContext context) async {
    Navigator.of(context).push(new PageTransition(widget: new AboutScreen()));
  }

  void _handleInputEvents(TimePageEvent event) {
    if(event is DateSelectedEvent){
      _currentDate = event.selectedDate;
      _loadTime(event.selectedDate);
    }

    if(event is DatePickerSelectedEvent){
      _currentDate = event.selectedDate;
      _analytics.logEvent(TimeEvent.click(EVENT_NAME.DATE_PICKER_USED));
      _loadTime(_currentDate);
    }

    if(event is OnAboutItemClicked){
      _analytics.logEvent(
          TimeEvent.click(EVENT_NAME.ACTION_ABOUT).setUser(_auth.getCurrentUser().name));
      _onAboutClicked(event.context);
    }

    if(event is LogoutItemClicked){
      _analytics.logEvent(
          TimeEvent.click(EVENT_NAME.ACTION_LOGOUT).setUser(_auth.getCurrentUser().name));

      _logout();
    }
    
    if(event is FabAddRecordClicked){
      _analytics.logEvent(
          TimeEvent.click(EVENT_NAME.NEW_RECORD_FAB_CLICKED)
              .setUser(_auth.getCurrentUser().name));
      _navigateToNextScreen(event.context);
    }

    if(event is EmptyScreenAddRecordClicked){
      _analytics.logEvent(
          TimeEvent.click(EVENT_NAME.NEW_RECORD_SCREEN_CLICKED)
              .setUser(_auth.getCurrentUser().name));
      _navigateToNextScreen(event.context);
    }

    if(event is OnTimeRecordItemClicked){
      _navigateToEditScreen(event.timeRecord, event.context);
    }

    if(event is OnItemDismissed){
      _analytics.logEvent(prefix0.NewRecordeEvent.click(prefix0.EVENT_NAME.SWIPE_TO_DELETE).setUser(_auth.getCurrentUser().name));
      onItemDismissed(event.timeRecord);
    }
  }
}