import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/member.dart';
import 'dart:async';
import 'package:tikal_time_tracker/network/credentials.dart';
import 'package:tikal_time_tracker/network/requests/reports_form.dart';
import 'package:tikal_time_tracker/network/requests/send_email_form.dart';
import 'package:tikal_time_tracker/network/requests/reset_password_form.dart';
import 'package:tikal_time_tracker/data/models.dart';

class TimeDateSource{
 Future<List<TimeRecord>> getAllTimeForDate(DateTime date){return null;}
 Future<dynamic> addTime(TimeRecord time){return null;}
 Future<dynamic> updateTime(TimeRecord time){return null;}
 Future<List<TimeRecord>> getRecordsBetweenDates(DateTime startDate, DateTime endDate){return null;}
 Future<dynamic> deleteTime(TimeRecord time){return null;}
 Future<int> deleteTimeRecordForDate(DateTime dateTime){return null;}
 Future<dynamic> singIn(String userName, String password){return null;}
 Future<dynamic> login(String email, String password){return null;}
 Future<dynamic> timePage(){return null;}
 Future<List<Member>> getAllMembers(Role role){return null;}
 Future<dynamic> reportsPage(Role role){return null;}
 Future<List<TimeRecord>> generateReport(ReportForm request){return null;}
 Future<dynamic> getReport(ReportForm request, Role role){return null;}
 Future<dynamic> resetPasswordPage(){return null;}
 Future<dynamic> resetPassword(ResetPasswordForm login){return null;}
 Future<dynamic> sendEmailPage(){return null;}
 Future<dynamic> sendEmail(SendEmailForm request){return null;}
 void updateCredentials(Credentials credentials){}
}