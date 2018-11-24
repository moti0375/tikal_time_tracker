import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_serializer/src/repo/repo.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:http/http.dart';
import 'package:client_cookie/client_cookie.dart';
import 'package:tikal_time_tracker/network/requests/login_request.dart';
import 'package:tikal_time_tracker/network/requests/reports_form.dart';
import 'package:tikal_time_tracker/network/requests/update_request.dart';
import 'package:tikal_time_tracker/network/requests/delete_request.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'credentials.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tikal_time_tracker/utils/utils.dart';

part  'time_tracker_api.jretro.dart';

@GenApiClient(path: "timetracker")
class TimeTrackerApi extends _$TimeTrackerApiClient implements ApiClient{
  @override
  resty.Route base;
  @override
  SerializerRepo serializers;

  Credentials credentials;

  TimeTrackerApi({this.base, this.serializers, this.credentials}){
    globalClient = IOClient();
    List<ClientCookie> cookies = List<ClientCookie>();
    List<int> convert = Utf8Encoder().convert("${credentials.signInUserName}:${credentials.signInPassword}");
    print("encoded: ${Base64Encoder().convert(convert)}");
    this.base.authHeader("Basic", Base64Encoder().convert(convert));
    this.base.after((resty.StringResponse response){

//      debugPrint("resty After: status: ${response.statusCode}, response headers: ${response.headers.toString()}");

      Map map = response.headers.map((key, value){
        return MapEntry(key, value);
      });

      String cookieStr = map["set-cookie"];
//      print("Cookies Str: $cookieStr");

      if(cookieStr != null){
        cookies.clear();
        cookies.addAll(Utils.cookies(cookieStr));
      }
    });

    this.base.before((b){  //This is 'before 'interceptor
      b.cookies(cookies);
    });
  }

  @GetReq(path: "login.php" )
  Future<dynamic> signIn();

  @PostReq(path: "login.php", metadata: const {'jar':true} )
  Future<dynamic> login(@AsForm() LoginForm request);

  @GetReq(path: "time.php")
  Future<dynamic> time();

  @GetReq(path: "time.php")
  Future<dynamic> timeForDate(@QueryParam("date") String date);

  @GetReq(path: "users.php")
  Future<dynamic> users();

  @GetReq(path: "reports.php")
  Future<dynamic> reports();

  @PostReq(path: "reports.php")
  Future<dynamic> generateReport(@AsForm() ReportForm request);

  @PostReq(path: "report.php")
  Future<dynamic> getReport();

  @PostReq(path: "time.php")
  Future<dynamic> addTime(@AsForm() TimeRecord request);

  @PostReq(path: "time_edit.php")
  Future<dynamic> updateTime(@QueryParam("id") int id, @AsForm() UpdateRequest request);

  @PostReq(path: "time_delete.php")
  Future<dynamic> timeDelete(@QueryParam("id") int id, @AsForm() DeleteRequest request);

}