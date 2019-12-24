import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/new_record_event.dart' as prefix0;
import 'package:tikal_time_tracker/analytics/events/time_event.dart';
import 'package:tikal_time_tracker/bloc_base/bloc_base_event.dart';
import 'package:tikal_time_tracker/data/exceptions/failed_login_exception.dart';
import 'package:tikal_time_tracker/pages/about_screen/about_screen.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_page.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/utils/page_transition.dart';

import '../../data/repository/time_records_repository.dart';
import '../../data/models.dart';

class DateSelectedEvent extends BlocBaseEvent{
  final DateTime selectedDate;
  DateSelectedEvent({@required this.selectedDate});
}

class TimePageBloc  {

  TimeRecordsRepository repository;
  DateTime _currentDate = DateTime.now();
  DateTime get selectedDate => _currentDate;
  BaseAuth auth;
  Analytics analytics;

  TimePageBloc({this.repository, this.auth, this.analytics}){
   _initializeEventsStream();
   analytics.logEvent(TimeEvent.impression(EVENT_NAME.TIME_PAGE_OPENED)
       .setUser(auth.getCurrentUser().name)
       .view());
  }

  StreamController<TimeReport> _timeStreamController = StreamController.broadcast();
  Stream<TimeReport> get timeReportStream => _timeStreamController.stream.asBroadcastStream();
  Sink<TimeReport> get _timeControllerSink => _timeStreamController.sink;

  StreamController<BlocBaseEvent> _timeEventsController = StreamController<BlocBaseEvent>();
  Sink<BlocBaseEvent> get _blocEventsSink => _timeEventsController.sink;


  Future<void> _loadTime(DateTime date) async {
    print("_loadTime: $date");
    repository.getAllTimeForDate(date).then((records) {
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
    analytics.logEvent(prefix0.NewRecordeEvent.click(prefix0.EVENT_NAME.SWIPE_TO_DELETE).setUser(auth.getCurrentUser().name));

    repository.deleteTime(item).then((value){
      print("onItemDismissed: ");
      _loadTime(_currentDate);
    });
  }

  void onDatePickerDateSelected(DateSelectedEvent date){
    analytics.logEvent(TimeEvent.click(EVENT_NAME.DATE_PICKER_USED));
    dateSelected(date);
  }

  void dateSelected(DateSelectedEvent date){
    _blocEventsSink.add(date);
  }

  void _initializeEventsStream() {
    _timeEventsController.stream.listen((event) {
      if(event is DateSelectedEvent){
        _currentDate = event.selectedDate;
        _loadTime(event.selectedDate);
      } else throw AppException(cause: "Unsupported event");
    });
  }

  void onAddFabClicked(BuildContext context){
    analytics.logEvent(
        TimeEvent.click(EVENT_NAME.NEW_RECORD_FAB_CLICKED)
            .setUser(auth.getCurrentUser().name));
    _navigateToNextScreen(context);
  }

  void onAddEmptyScreenTap(BuildContext context){
    analytics.logEvent(
        TimeEvent.click(EVENT_NAME.NEW_RECORD_SCREEN_CLICKED)
            .setUser(auth.getCurrentUser().name));
    _navigateToNextScreen(context);
  }
  void navigateRecordEditPage(TimeRecord timeRecord, BuildContext context){
    if (timeRecord != null) {
      _navigateToEditScreen(timeRecord, context);
    } else {
      _navigateToNextScreen(context);
    }
  }

  _navigateToEditScreen(TimeRecord timeRecord, BuildContext context) {
//    print("_navigateToEditScreen: ");
    print("_navigateToEditScreen: projects ${auth.getCurrentUser().projects}");
    final projects = auth.getCurrentUser().projects;

    var newRecordPage = NewRecordPage.create(projects, timeRecord);
    Navigator.of(context)
        .push(new PageTransition(
        widget: newRecordPage))
        .then((value) {
//      print("got value from page");
      if (value != null) {
        if (value is TimeRecord) {
          dateSelected(DateSelectedEvent(selectedDate: value.date));
        }
      } else {
        dateSelected(DateSelectedEvent(selectedDate: timeRecord.date));
      }
    });
  }

  _navigateToNextScreen(BuildContext context) {
    final projects = auth.getCurrentUser().projects;
    print("_navigateToNextScreen: " + projects.toString());

    var newRecordPage = NewRecordPage.create(projects, null);

    Navigator.of(context)
        .push(new PageTransition(
        widget: newRecordPage))
        .then((value) {
//      print("got value from page");
      if (value != null) {
        if (value is TimeRecord) {
          dateSelected(DateSelectedEvent(selectedDate: value.date));
        }
      } else {
        dateSelected(DateSelectedEvent(selectedDate: selectedDate));
      }
    });
  }

  void logout() async {
    analytics.logEvent(
        TimeEvent.click(EVENT_NAME.ACTION_LOGOUT).setUser(auth.getCurrentUser().name));
    await auth.logout();
  }

  void onAboutClicked(BuildContext context) async {
    analytics.logEvent(
        TimeEvent.click(EVENT_NAME.ACTION_ABOUT).setUser(auth.getCurrentUser().name));
    Navigator.of(context).push(new PageTransition(widget: new AboutScreen()));
  }
}