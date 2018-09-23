import '../models.dart';
import 'dart:async';
import '../../network/credentials.dart';

class TimeDateSource{
 Future<List<TimeRecord>> getAllTimeForDate(DateTime date){return null;}
 Future<TimeRecord> addTimeForDate(TimeRecord time){return null;}
 Future<List<TimeRecord>> getRecordsBetweenDates(DateTime startDate, DateTime endDate){return null;}
 Future<int> deleteTime(TimeRecord time){return null;}
 Future<int> deleteTimeRecordForDate(DateTime dateTime){return null;}
 Future<dynamic> singIn(String userName, String password){return null;}
 void updateCredentials(Credentials credentials){}
}