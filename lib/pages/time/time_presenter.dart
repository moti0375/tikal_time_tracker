import 'dart:async';

import '../../data/repository/time_records_repository.dart';
import '../../data/models.dart';

class TimePageBloc  {

  TimeRecordsRepository repository;
  TimePageBloc({this.repository});
  DateTime currentDate;
  StreamController<TimeReport> timeStreamController = StreamController.broadcast();
  Stream<TimeReport> get timeReportStream => timeStreamController.stream.asBroadcastStream();

  Future<void> loadTime(DateTime date) async {
    this.currentDate = date;
    repository.getAllTimeForDate(date).then((records) {
      timeStreamController.add(records);
    }, onError: (e){
      print("PagePresenter There was an error: $e");
      if(e is RangeError){
        timeStreamController.addError(e);
      }else{
        print(e);
      }
    });
  }

  void dismiss(){
    timeStreamController.close();
  }

  void onItemDismissed(TimeRecord item) {
    print("onItemDismissed: ${item.toString()}");

    repository.deleteTime(item).then((value){
      print("onItemDismissed: ");
      loadTime(currentDate);
    });
  }
}