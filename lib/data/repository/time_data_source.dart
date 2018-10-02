import '../models.dart';
import '../member.dart';
import 'dart:async';
import '../../network/credentials.dart';
import '../../network/requests/login_request.dart';
import '../../network/requests/reports_form.dart';

class TimeDateSource{
 Future<List<TimeRecord>> getAllTimeForDate(DateTime date){return null;}
 Future<TimeRecord> addTimeForDate(TimeRecord time){return null;}
 Future<List<TimeRecord>> getRecordsBetweenDates(DateTime startDate, DateTime endDate){return null;}
 Future<int> deleteTime(TimeRecord time){return null;}
 Future<int> deleteTimeRecordForDate(DateTime dateTime){return null;}
 Future<dynamic> singIn(String userName, String password){return null;}
 Future<dynamic> login(String email, String password){return null;}
 Future<dynamic> timePage(){return null;}
 Future<List<Member>> getAllMembers(){return null;}
 Future<dynamic> reportsPage(){return null;}
 Future<List<TimeRecord>> generateReport(ReportForm request){return null;}
 Future<dynamic> getReport(ReportForm request){return null;}
 void updateCredentials(Credentials credentials){}
}