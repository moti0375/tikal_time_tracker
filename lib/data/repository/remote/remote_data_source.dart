import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/network/requests/send_email_form.dart';
import 'package:tikal_time_tracker/network/time_tracker_api.dart';
import 'package:tikal_time_tracker/network/requests/reports_form.dart';
import 'package:tikal_time_tracker/network/requests/update_request.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:tikal_time_tracker/network/serializers/from_request_serializer.dart';
import 'package:tikal_time_tracker/network/serializers/form_serializer.dart';
import 'package:tikal_time_tracker/network/serializers/add_time_serializer.dart';
import 'package:tikal_time_tracker/network/serializers/delete_request_serializer.dart';
import 'package:tikal_time_tracker/network/serializers/reports_form_serializer.dart';
import 'package:tikal_time_tracker/network/serializers/reset_password_serializer.dart';
import 'package:tikal_time_tracker/network/serializers/update_time_serializer.dart';
import 'package:tikal_time_tracker/network/requests/delete_request.dart';
import 'package:tikal_time_tracker/network/requests/login_request.dart';
import 'package:tikal_time_tracker/network/requests/reset_password_form.dart';
import 'package:tikal_time_tracker/network/credentials.dart';
import 'dart:convert';
import 'package:tikal_time_tracker/data/dom/dom_parser.dart';


import '../time_data_source.dart';

class RemoteDateSource implements TimeDateSource {
  TimeTrackerApi api;
  JsonRepo serializers = JsonRepo();
  Credentials credentials;
  DomParser parser = DomParser();

  RemoteDateSource({this.credentials}) {
    _setApi(credentials);
  }

  @override
  Future<dynamic> addTime(TimeRecord time) {
    return api.addTime(time);
  }

  @override
  Future<dynamic> deleteTime(TimeRecord time) {
    return api.timeDelete(time.id, DeleteRequest(timeRecord: time));
  }

  @override
  Future<int> deleteTimeRecordForDate(DateTime dateTime) {
    // TODO: implement deleteTimeRecordForDate
  }

  @override
  Future<List<TimeRecord>> getAllTimeForDate(DateTime date) {
    String month = date.month < 10 ? "0${date.month}" : "${date.month}";
    String day = date.day < 10 ? "0${date.day}" : "${date.day}";
    return api.timeForDate("${date.year}-$month-$day").then((response){
      return parser.parseTimePage(response.toString());
    });
  }

  @override
  Future<List<TimeRecord>> getRecordsBetweenDates(
      DateTime startDate, DateTime endDate) {
    // TODO: implement getRecordsBetweenDates
  }

  @override
  Future<dynamic> singIn(String userName, String password) {
//    api.setCredentials(userName, password);
    return api.signIn();
  }

  @override
  void updateCredentials(Credentials credentials) {
    print("remoteDateSource: updateCredentials: ");
    _setApi(credentials);
  }

  _setApi(Credentials credentials) {
    print("remoteDateSource: _setApi: ");
    serializers.add(FormRequestSerializer());
    serializers.add(FormSerializer());
    serializers.add(ReportsFormSerializer());
    serializers.add(AddTimeSerializer());
    serializers.add(UpdateTimeSerializer());
    serializers.add(DeleteRequestSerializer());
    serializers.add(ResetPasswordSerializer());
    api = TimeTrackerApi(
        base: route("https://planet.tikalk.com").before((route) {
          print("Metadata: ${route.metadataMap}");
        }),
        serializers: serializers, credentials: credentials);
  }

  @override
  Future<dynamic> login(String email, String password) {

    List<int> emailConvert = Utf8Encoder().convert(email);
    List<int> passwordConvert = Utf8Encoder().convert(password);
    print("encoded: ${Base64Encoder().convert(emailConvert)}");

    return api.login(LoginForm(Login: email, Password: password));
  }

  @override
  Future timePage() {
    return api.time();
  }

  @override
  Future<List<Member>> getAllMembers(Role role) {
    return api.users().then((response){
      return parser.parseUsersPage(response, role);
    });
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
    debugPrint("resetPassword: $login");

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
    return api.sendEmail(request);
  }
}
