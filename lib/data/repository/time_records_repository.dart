import 'dart:async';
import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/network/requests/reports_form.dart';
import 'package:tikal_time_tracker/network/requests/reset_password_form.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/repository/time_data_source.dart';
import 'package:tikal_time_tracker/data/repository/local/local_data_source.dart';
import 'package:tikal_time_tracker/data/repository/remote/remote_data_source.dart';
import 'package:tikal_time_tracker/network/credentials.dart';
import 'package:tikal_time_tracker/network/requests/send_email_form.dart';
import 'package:tikal_time_tracker/network/time_tracker_api.dart';


class TimeRecordsRepository implements TimeDateSource{

  static final String _TAG = "TimeRecordsRepository";
  Credentials credentials;
  final TimeDateSource dateSource = LocalDataSource();
  TimeDateSource remoteDateSource;

  static TimeRecordsRepository _instance;
  static TimeRecordsRepository get instance => _instance;


  static TimeRecordsRepository init(TimeDateSource remoteDataSource, Credentials credentials) {
    if (_instance == null) {
      print("$_TAG : init: ${credentials.toString()}");
      _instance = TimeRecordsRepository._internal(remoteDataSource, credentials);
    }
    return _instance;
  }

  TimeRecordsRepository._internal(this.remoteDateSource, this.credentials);

  factory TimeRecordsRepository(){
    return _instance;
  }

  @override
  Future<dynamic> addTime(TimeRecord time) {
    print("addTime: $time");
    return remoteDateSource.addTime(time);
  }

  @override
  Future<dynamic> deleteTime(TimeRecord time) {
    return remoteDateSource.deleteTime(time);
  }

  @override
  Future<TimeReport> getAllTimeForDate(DateTime date) {
    return remoteDateSource.getAllTimeForDate(date);
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
  void updateCredentials(Credentials credentials) {
    print("repository: updateCredentials ");
//    remoteDateSource.updateCredentials(credentials);
  }


  @override
  Future timePage() {
    return remoteDateSource.timePage();
  }

  @override
  Stream<List<Member>> getAllMembers(Role role) {
    return remoteDateSource.getAllMembers(role);
  }

  @override
  Future<List<TimeRecord>> generateReport(ReportForm request) {
    return remoteDateSource.generateReport(request);
  }

  @override
  Future<dynamic> reportsPage(Role role) {
    return remoteDateSource.reportsPage(role);
  }

  @override
  Future getReport(ReportForm request, Role role) {
    return remoteDateSource.getReport(request, role);
  }

  @override
  Future updateTime(TimeRecord time) {
    return remoteDateSource.updateTime(time);
  }

  @override
  Future resetPasswordPage() {
    print("resetPasswordPage: ");
    return remoteDateSource.resetPasswordPage();
  }

  @override
  Future resetPassword(ResetPasswordForm request) {
    return remoteDateSource.resetPassword(request);
  }

  @override
  Future sendEmail(SendEmailForm request) {
    return remoteDateSource.sendEmail(request);
  }

  @override
  Future<SendEmailForm> sendEmailPage() {
    return remoteDateSource.sendEmailPage();
  }

  @override
  Future<DateTime> getIncompleteRecordById(int id) {
    return remoteDateSource.getIncompleteRecordById(id);
  }

}