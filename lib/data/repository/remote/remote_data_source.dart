import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/remote.dart';
import 'package:tikal_time_tracker/network/requests/send_email_form.dart';
import 'package:tikal_time_tracker/network/time_tracker_api.dart';
import 'package:tikal_time_tracker/network/requests/reports_form.dart';
import 'package:tikal_time_tracker/network/requests/update_request.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:tikal_time_tracker/network/requests/delete_request.dart';
import 'package:tikal_time_tracker/network/requests/reset_password_form.dart';
import 'package:tikal_time_tracker/network/credentials.dart';
import 'package:tikal_time_tracker/data/dom/dom_parser.dart';
import 'package:tikal_time_tracker/services/locator/locator.dart';


import '../time_data_source.dart';

class RemoteDateSource implements TimeDateSource {
  TimeTrackerApi api;
  JsonRepo serializers = JsonRepo();
  Credentials credentials;
  DomParser parser = locator<DomParser>();

  RemoteDateSource({this.api});

  @override
  Future<dynamic> addTime(TimeRecord time) async {
    String apiResponse = await api.addTime(time);
    apiResponse = parser.parseSaveAndAddTimeResponse(apiResponse);
    return apiResponse;
  }

  @override
  Future<dynamic> deleteTime(TimeRecord time) {
    return api.timeDelete(time.id, DeleteRequest(timeRecord: time));
  }

  @override
  Future<int> deleteTimeRecordForDate(DateTime dateTime) {
    return null;
  }

  @override
  Future<TimeReport> getAllTimeForDate(DateTime date) {
    String month = date.month < 10 ? "0${date.month}" : "${date.month}";
    String day = date.day < 10 ? "0${date.day}" : "${date.day}";
    return api.timeForDate("${date.year}-$month-$day").then((response){
      return parser.parseTimePage(response.toString());
    });
  }

  @override
  Future<List<TimeRecord>> getRecordsBetweenDates(
      DateTime startDate, DateTime endDate) {
    return null;
  }


  @override
  void updateCredentials(Credentials credentials) {
    api.updateAuthHeader(credentials);
  }

  @override
  Future timePage() {
    return api.time();
  }

  @override
  Stream<List<Member>> getAllMembers(Role role) async* {
    String response = await api.users();
    yield parser.parseUsersPage(response, role);
  }

  @override
  Future<dynamic> reportsPage(Role role) {
    return api.reports().then((response){
      //debugPrint("Response: ${response.toString()}");
      if(role == Role.Manager || role == Role.CoManager || role == Role.TopManager){
        List<Member> members = parser.parseGenerateReportPage(response);
        return members;
      }
      return null;
    }, onError: (e){
      debugPrint("There was an error loading reportPage: ${e.toString()}");
    });
  }

  @override
  Future<List<TimeRecord>> generateReport(ReportForm request) {
    return api.generateReport(request).then((response){
      debugPrint("remoteDataSource: report ${response.toString()}");
      List<TimeRecord> result = List<TimeRecord>();
      return result;
    }, onError: (e){
      print("There was an error: ${e.toString()}");
    });
  }

  @override
  Future<dynamic> getReport(ReportForm request, Role role) {
    return api.getReport().then((response){
      print("RemoteDateSource: getReport");
//      debugPrint("getReport: report ${response.toString()}");
      return parser.parseReportPage(response, role);
    });
  }

  @override
  Future updateTime(TimeRecord time) {
    return api.updateTime(time.id, UpdateRequest(timeRecord: time));
  }

  @override
  Future resetPasswordPage() {
    return api.resetPassword().then((response){
      debugPrint("resetPasswordPage response: $response");
    });
  }

  @override
  Future resetPassword(ResetPasswordForm request) {
    return api.resetPasswordRequest(request).then((response){
      debugPrint("resetPasswordRequest response: $response");
      return parser.parseResetPasswordResponse(response.toString());
    }, onError: (e){
      print("There was an error: ${e.toString()}");
    });
  }

  @override
  Future<SendEmailForm> sendEmailPage() {
    return api.sendEmailPage().then((response){
      return parser.parseSendEmailPage(response.toString());
    }, onError: (e){
      print("sendEmailPage: There was an error: ${e.toString()}");
    });
  }

  @override
  Future sendEmail(SendEmailForm request) {
    return api.sendEmail(request).then((response){
      return parser.parseSendEmailResponse(response);
    });
  }

  @override
  Future<DateTime> getIncompleteRecordById(int id) async {
    return api.getIncompleteRecordById(id).then((response){
      return parser.parseIncompleteRecordResponse(response);
    });
  }

  @override
  Future<Remote> getRemoteFromRecord(int recordId) {
    return api.getIncompleteRecordById(recordId).then((response) => parser.parseRemoteFromResponse(response));
  }
}
