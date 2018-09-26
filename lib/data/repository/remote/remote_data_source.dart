import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import '../../../data/models.dart';
import '../../../network/time_tracker_api.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import '../../../network/serializers/from_request_serializer.dart';
import '../../../network/serializers/form_serializer.dart';
import '../../../network/requests/login_request.dart';
import '../../../network/credentials.dart';
import 'dart:convert';


import '../time_data_source.dart';

class RemoteDateSource implements TimeDateSource {
  TimeTrackerApi api;
  JsonRepo serializers = JsonRepo();
  Credentials credentials;

  RemoteDateSource({this.credentials}) {
    _setApi(credentials);
  }

  @override
  Future<TimeRecord> addTimeForDate(TimeRecord time) {
    // TODO: implement addTimeForDate
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
    // TODO: implement getAllTimeForDate
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
}
