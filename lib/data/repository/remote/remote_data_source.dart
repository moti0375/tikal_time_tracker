import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart';
import '../../../data/member.dart';
import '../../../data/models.dart';
import '../../../network/time_tracker_api.dart';
import '../../../network/requests/reports_form.dart';
import '../../../network/requests/update_request.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import '../../../network/serializers/from_request_serializer.dart';
import '../../../network/serializers/form_serializer.dart';
import '../../../network/serializers/add_time_serializer.dart';
import '../../../network/serializers/id_request_serializer.dart';
import '../../../network/serializers/reports_form_serializer.dart';
import '../../../network/serializers/update_time_serializer.dart';
import '../../../network/requests/login_request.dart';
import '../../../network/credentials.dart';
import 'dart:convert';
import '../../dom/dom_parser.dart';


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
  Future<int> deleteTime(TimeRecord time) {
    // TODO: implement deleteTime
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
    serializers.add(IdRequestSerializer());
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
  Future<List<Member>> getAllMembers() {
    return api.users().then((response){
      return parser.parseUsersPage(response);
    });
  }

  @override
  Future<dynamic> reportsPage() {
    return api.reports();
  }

  @override
  Future<List<TimeRecord>> generateReport(ReportForm request) {
    return api.generateReport(request).then((response){
//      debugPrint("remoteDataSource: report ${response.toString()}");
      List<TimeRecord> result = List<TimeRecord>();
      return result;
    }, onError: (e){
      print("There was an error: ${e.toString()}");
    });
  }

  @override
  Future getReport(ReportForm request) {
    return api.getReport();
  }

  @override
  Future updateTime(TimeRecord time) {
    return api.updateTime(time.id, UpdateRequest(timeRecord: time));
  }
}
