import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_serializer/src/repo/repo.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:http/http.dart';
import '../network/requests/login_request.dart';

import 'dart:async';

part  'time_tracker_api.jretro.dart';

@GenApiClient(path: "timetracker")
class TimeTrackerApi extends _$TimeTrackerApiClient implements ApiClient{
  @override
  resty.Route base;
  @override
  SerializerRepo serializers;

  TimeTrackerApi({this.base, this.serializers}){
    this.base.authHeader("Authorization", "{login: motib, password: motibtik23}");
    globalClient = IOClient();
  }

  @PostReq(path: "login.php" )
  Future<String> login(@AsJson() FormRequest formRequest);

}