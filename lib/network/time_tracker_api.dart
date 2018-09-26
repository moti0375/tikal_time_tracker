import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_serializer/src/repo/repo.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:http/http.dart';
import 'package:client_cookie/client_cookie.dart';
import '../network/requests/login_request.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'credentials.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/utils.dart';

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
//      debugPrint("resty After: ${response.headers.toString()}" );

      Map map = response.headers.map((key, value){
        return MapEntry(key, value);
      });

      String cookieStr = map["set-cookie"];
      print("Cookies Str: $cookieStr");

      if(cookieStr != null){
        cookies.clear();
        cookies.addAll(Utils.cookies(cookieStr));
      }
    });

    this.base.before((b){
      b.cookies(cookies);
    });
  }

  @GetReq(path: "login.php" )
  Future<dynamic> signIn();

  @PostReq(path: "login.php", metadata: const {'jar':true} )
  Future<dynamic> login(@AsForm() LoginForm request);

  @GetReq(path: "time.php")
  Future<dynamic> time();
}