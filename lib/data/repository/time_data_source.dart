import '../models.dart';
import 'dart:async';

class TimeDateSource{
 Future<List<TimeRecord>> getAllTimeForDate(DateTime date){return null;}
 Future<TimeRecord> addTimeForDate(TimeRecord time){return null;}
 Future<int> deleteTime(TimeRecord time){return null;}
 Future<int> deleteTimeRecordForDate(DateTime dateTime){return null;}
}