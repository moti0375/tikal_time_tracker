import 'dart:async';

import 'package:tikal_time_tracker/bloc_base/bloc_base_event.dart';
import 'package:tikal_time_tracker/data/exceptions/failed_login_exception.dart';

import '../../data/repository/time_records_repository.dart';
import '../../data/models.dart';

class TimePageBloc  {

  TimeRecordsRepository repository;
  DateTime _currentDate = DateTime.now();
  DateTime get selectedDate => _currentDate;

  TimePageBloc({this.repository}){
   _initializeEventsStream();
  }

  StreamController<TimeReport> _timeStreamController = StreamController.broadcast();
  Stream<TimeReport> get timeReportStream => _timeStreamController.stream.asBroadcastStream();
  Sink<TimeReport> get _timeControllerSink => _timeStreamController.sink;

  StreamController<BlocBaseEvent> _timeEventsController = StreamController<BlocBaseEvent>();
  Sink<BlocBaseEvent> get _blocEventsSink => _timeEventsController.sink;


  Future<void> _loadTime(DateTime date) async {
    repository.getAllTimeForDate(date).then((records) {
      _timeControllerSink.add(records);
    }, onError: (e){
      print("TimePageBloc There was an error: $e");
      if(e is RangeError){
        _timeStreamController.addError(e);
      }else{
        print(e);
      }
    });
  }

  void dispose(){
    print("TimePageBloc: dispose");
    _timeStreamController.close();
    _timeEventsController.close();
  }

  void onItemDismissed(TimeRecord item) {
    print("onItemDismissed: ${item.toString()}");
    repository.deleteTime(item).then((value){
      print("onItemDismissed: ");
      _loadTime(_currentDate);
    });
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
}