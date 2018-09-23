import 'dart:async';
import '../models.dart';
import 'time_data_source.dart';
import '../../data/repository/local/local_data_source.dart';
import '../../data/repository/remote/remote_data_source.dart';
import '../../network/credentials.dart';


class TimeRecordsRepository implements TimeDateSource{

  static final String _TAG = "TimeRecordsRepository";
  Credentials credentials;
  final TimeDateSource dateSource = LocalDataSource();
  TimeDateSource remoteDateSource;

  static TimeRecordsRepository _instance;
  static TimeRecordsRepository get instance => _instance;


  static TimeRecordsRepository init(Credentials credentials) {
    if (_instance == null) {
      print("$_TAG : init: ${credentials.toString()}");
      _instance = TimeRecordsRepository._internal(credentials);
    }
    return _instance;
  }

  TimeRecordsRepository._internal(this.credentials){
    print("$_TAG: _internal: ${this.credentials}");
   remoteDateSource = RemoteDateSource(credentials: this.credentials);
  }

  factory TimeRecordsRepository(){
    return _instance;
  }

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

  @override
  Future<List<TimeRecord>> getRecordsBetweenDates(DateTime startDate, DateTime endDate) {
    print("getRecordsBetweenDates:");

  return dateSource.getRecordsBetweenDates(startDate, endDate);
  }

  @override
  Future<dynamic> singIn(String userName, String password) {
    return remoteDateSource.singIn(userName, password);
  }

  @override
  void updateCredentials(Credentials credentials) {
    print("repository: updateCredentials ");
    remoteDateSource.updateCredentials(credentials);
  }

}