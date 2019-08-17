import 'dart:async';

import '../../data/repository/time_records_repository.dart';
import '../../data/models.dart';

class TimePageBloc  {

  TimeRecordsRepository repository;
  DateTime currentDate = DateTime.now();

  TimePageBloc({this.repository}){
   dateSelected(currentDate) ;
  }

  StreamController<TimeReport> timeStreamController = StreamController.broadcast();
  Stream<TimeReport> get timeReportStream => timeStreamController.stream.asBroadcastStream();

  Future<void> _loadTime(DateTime date) async {
    this.currentDate = date;
    repository.getAllTimeForDate(date).then((records) {
      timeStreamController.add(records);
    }, onError: (e){
      print("TimePageBloc There was an error: $e");
      if(e is RangeError){
        timeStreamController.addError(e);
      }else{
        print(e);
      }
    });
  }

  void dispose(){
    print("TimePageBloc: dispose");
    timeStreamController.close();
  }

  void onItemDismissed(TimeRecord item) {
    print("onItemDismissed: ${item.toString()}");

    repository.deleteTime(item).then((value){
      print("onItemDismissed: ");
      _loadTime(currentDate);
    });
  }

  void dateSelected(DateTime date){
    currentDate = date;
    _loadTime(date);
  }
}