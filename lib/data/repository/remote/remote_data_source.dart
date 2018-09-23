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

import '../time_data_source.dart';
class RemoteDateSource implements TimeDateSource{

  TimeTrackerApi api;
  JsonRepo serializers = JsonRepo();

  RemoteDateSource(){
    serializers.add(FormRequestSerializer());
    serializers.add(FormSerializer());

    api = TimeTrackerApi(base: route("https://planet.tikalk.com").before((route){
      print("Metadata: ${route.metadataMap}");
    }), serializers: serializers);
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
  Future<List<TimeRecord>> getRecordsBetweenDates(DateTime startDate, DateTime endDate) {
    // TODO: implement getRecordsBetweenDates
  }

  @override
  Future<dynamic> login() {
    return api.login(new FormRequest(form: new Form(login: "motib", password: "motibtik23")));
  }

}