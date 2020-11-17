import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/remote.dart';
import 'package:tikal_time_tracker/network/dio_network_adapter.dart';
import 'package:tikal_time_tracker/network/requests/send_email_form.dart';
import 'package:tikal_time_tracker/network/requests/reports_form.dart';
import 'package:tikal_time_tracker/network/requests/update_request.dart';
import 'package:tikal_time_tracker/network/requests/delete_request.dart';
import 'package:tikal_time_tracker/network/requests/reset_password_form.dart';
import 'package:tikal_time_tracker/network/credentials.dart';
import 'package:tikal_time_tracker/data/dom/dom_parser.dart';


import '../time_data_source.dart';

class RemoteDateSource implements TimeDateSource {
  final DioNetworkAdapter _adapter;
  final DomParser parser;
  Credentials credentials;

  RemoteDateSource(this._adapter, {this.parser});

  @override
  Future<dynamic> addTime(TimeRecord time) async {
    String apiResponse = await _adapter.addTime(time);
    apiResponse = parser.parseSaveAndAddTimeResponse(apiResponse);
    return apiResponse;
  }

  @override
  Future<dynamic> deleteTime(TimeRecord time) {
    return _adapter.deleteTime(time.id, DeleteRequest(timeRecord: time));
  }

  @override
  Future<TimeReport> getAllTimeForDate(DateTime date) {
    String month = date.month < 10 ? "0${date.month}" : "${date.month}";
    String day = date.day < 10 ? "0${date.day}" : "${date.day}";
    return _adapter.timeForDate("${date.year}-$month-$day").then((response){
      return parser.parseTimePage(response.toString());
    });
  }

  @override
  Future timePage() {
    return _adapter.time();
  }

  @override
  Stream<List<Member>> getAllMembers(Role role) async* {
    String response = await _adapter.users();
    yield parser.parseUsersPage(response, role);
  }

  @override
  Future<dynamic> reportsPage(Role role) {
    return _adapter.reports().then((response){
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
    return _adapter.generateReport(request).then((response){
      debugPrint("remoteDataSource: report ${response.toString()}");
      List<TimeRecord> result = List<TimeRecord>();
      return result;
    }, onError: (e){
      print("There was an error: ${e.toString()}");
    });
  }

  @override
  Future<List<TimeRecord>> getReport(ReportForm request, Role role) {
    return _adapter.getReport().then((response){
      print("RemoteDateSource: getReport");
//      debugPrint("getReport: report ${response.toString()}");
      return parser.parseReportPage(response, role);
    });
  }

  @override
  Future updateTime(TimeRecord time) {
    return _adapter.updateTime(time.id, UpdateRequest(timeRecord: time));
  }

  @override
  Future resetPasswordPage() {
    return _adapter.resetPassword().then((response){
      debugPrint("resetPasswordPage response: $response");
    });
  }

  @override
  Future resetPassword(ResetPasswordForm request) {

    String signInUsername = request.login.split("@")[0];
    String signInPassword = "${signInUsername}tik23";

    _adapter.updateAuthHeader(Credentials(signInUserName: signInUsername, signInPassword: signInPassword));

    return _adapter.resetPasswordRequest(request).then((response){
      return parser.parseResetPasswordResponse(response.toString());
    }, onError: (e){
      print("There was an error: ${e.toString()}");
    });
  }

  @override
  Future<SendEmailForm> sendEmailPage() {
    return _adapter.sendEmailPage().then((response){
      return parser.parseSendEmailPage(response.toString());
    }, onError: (e){
      print("sendEmailPage: There was an error: ${e.toString()}");
    });
  }

  @override
  Future sendEmail(SendEmailForm request) {
    return _adapter.sendEmail(request).then((response){
      return parser.parseSendEmailResponse(response);
    });
  }

  @override
  Future<DateTime> getIncompleteRecordById(int id) async {
    return _adapter.getIncompleteRecordById(id).then((response){
      return parser.parseIncompleteRecordResponse(response);
    });
  }

  @override
  Future<Remote> getRemoteFromRecord(int recordId) {
    return _adapter.getIncompleteRecordById(recordId).then((response) => parser.parseRemoteFromResponse(response));
  }
}
