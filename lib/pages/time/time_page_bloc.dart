import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/analytics/events/base_event.dart';
import 'package:tikal_time_tracker/bloc_base/base_state.dart';
import 'package:tikal_time_tracker/bloc_base/bloc_base_event.dart';
import 'package:tikal_time_tracker/data/exceptions/failed_login_exception.dart';

import '../../data/repository/time_records_repository.dart';
import '../../data/models.dart';
import 'package:bloc/bloc.dart';

class DateSelectedEvent extends BlocBaseEvent {
  final DateTime selectedDate;

  DateSelectedEvent({@required this.selectedDate});
}

class TimePageBloc extends Bloc<BlocBaseEvent, BaseState> {

  TimeRecordsRepository repository;
  DateTime _currentDate = DateTime.now();

  DateTime get selectedDate => _currentDate;

  TimePageBloc({this.repository}) {
    _initializeEventsStream();
  }

  StreamController<TimeReport> _timeStreamController = StreamController
      .broadcast();

  Stream<TimeReport> get timeReportStream =>
      _timeStreamController.stream.asBroadcastStream();

  Sink<TimeReport> get _timeControllerSink => _timeStreamController.sink;

  StreamController<BlocBaseEvent> _timeEventsController = StreamController<
      BlocBaseEvent>();

  Sink<BlocBaseEvent> get _blocEventsSink => _timeEventsController.sink;


  Future<void> _loadTime(DateTime date) async {

  }

  void dispose() {
    print("TimePageBloc: dispose");
    _timeStreamController.close();
    _timeEventsController.close();
  }

  void onItemDismissed(TimeRecord item) {
    print("onItemDismissed: ${item.toString()}");
    repository.deleteTime(item).then((value) {
      print("onItemDismissed: ");
      _loadTime(_currentDate);
    });
  }

  void dateSelected(DateSelectedEvent event) {
    dispatch(event);
    //_blocEventsSink.add(event);
  }

  void _initializeEventsStream() {
    _timeEventsController.stream.listen((event) {
      if (event is DateSelectedEvent) {
        _currentDate = event.selectedDate;
        _loadTime(event.selectedDate);
      } else
        throw AppException(cause: "Unsupported event");
    });
  }

  @override
  // TODO: implement initialState
  BaseState get initialState => InitialState();

  @override
  Stream<BaseState> mapEventToState(BlocBaseEvent event) async* {
    if (event is DateSelectedEvent) {
      _currentDate = event.selectedDate;
      yield LoadingState();
      try{
        TimeReport report = await repository.getAllTimeForDate(_currentDate);
        yield LoadingCompleted<TimeReport>(data: report);
      } catch (e){
        yield ErrorState(e);
      }
    }
  }

}