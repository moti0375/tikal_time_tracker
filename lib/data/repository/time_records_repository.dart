import 'dart:async';
import '../models.dart';
import 'time_data_source.dart';
import 'local_data_source.dart';


class TimeRecordsRepository implements TimeDateSource{

  final TimeDateSource dateSource = LocalDataSource();

  static final TimeRecordsRepository _instance = TimeRecordsRepository._internal();

  factory TimeRecordsRepository(){
    return _instance;
  }

  TimeRecordsRepository._internal();

  @override
  Future<TimeRecord> addTimeForDate(TimeRecord time) {
    print("addTimeForDate: $time");
    return dateSource.addTimeForDate(time);
  }

  @override
  Future<int> deleteTime(TimeRecord time) {
    return dateSource.deleteTime(time);
  }

  @override
  Future<List<TimeRecord>> getAllTimeForDate(DateTime date) {
    return dateSource.getAllTimeForDate(date);
  }

  @override
  Future<int> deleteTimeRecordForDate(DateTime dateTime) {
    return dateSource.deleteTimeRecordForDate(dateTime);
  }

}