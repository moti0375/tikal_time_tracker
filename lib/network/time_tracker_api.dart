import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:client_cookie/client_cookie.dart';
import 'package:meta/meta.dart';
import 'package:tikal_time_tracker/network/requests/login_request.dart';
import 'package:tikal_time_tracker/network/requests/reports_form.dart';
import 'package:tikal_time_tracker/network/requests/update_request.dart';
import 'package:tikal_time_tracker/network/requests/delete_request.dart';
import 'package:tikal_time_tracker/network/requests/send_email_form.dart';
import 'package:tikal_time_tracker/network/requests/reset_password_form.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/network/serializers/add_time_serializer.dart';
import 'package:tikal_time_tracker/network/serializers/delete_request_serializer.dart';
import 'package:tikal_time_tracker/network/serializers/form_serializer.dart';
import 'package:tikal_time_tracker/network/serializers/from_request_serializer.dart';
import 'package:tikal_time_tracker/network/serializers/reports_form_serializer.dart';
import 'package:tikal_time_tracker/network/serializers/reset_password_serializer.dart';
import 'package:tikal_time_tracker/network/serializers/send_email_form_serializer.dart';
import 'package:tikal_time_tracker/network/serializers/update_time_serializer.dart';
import 'dart:convert';
import 'credentials.dart';
import 'dart:async';
import 'package:tikal_time_tracker/utils/utils.dart';
import 'package:http/http.dart';

part  'time_tracker_api.jretro.dart';

@GenApiClient(path: "timetracker")
class TimeTrackerApi extends _$TimeTrackerApiClient implements ApiClient{
  static const  String BASE_URL = "https://planet.tikalk.com";

  @override
  resty.Route base;
  @override
  SerializerRepo serializers;

  Credentials credentials;


  factory TimeTrackerApi.create(){
    JsonRepo serializers = JsonRepo();
    serializers.add(FormRequestSerializer());
    serializers.add(FormSerializer());
    serializers.add(ReportsFormSerializer());
    serializers.add(AddTimeSerializer());
    serializers.add(UpdateTimeSerializer());
    serializers.add(DeleteRequestSerializer());
    serializers.add(ResetPasswordSerializer());
    serializers.add(SendEmailSerializer());
    return TimeTrackerApi._internal(
        base: route(BASE_URL).before((route) {
          print("before: ${route.toString()}");
          print("Metadata: ${route.metadataMap}");
        }),
        serializers: serializers);
  }


  TimeTrackerApi._internal({@required this.base, @required this.serializers}){
    globalClient = Client();
    List<ClientCookie> cookies = List<ClientCookie>();
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

  void updateAuthHeader(Credentials credentials){
    print("TimeTrackerApi: updateAuthHeader ${credentials.toString()}");
    List<int> utf8Convert = Utf8Encoder().convert("${credentials.signInUserName}:${credentials.signInPassword}");
    this.base.authHeader("Basic", Base64Encoder().convert(utf8Convert));
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

  @PostReq(path: "time_edit.php")
  Future<dynamic> getIncompleteRecordById(@QueryParam("id") int id);

  @PostReq(path: "time_delete.php")
  Future<dynamic> timeDelete(@QueryParam("id") int id, @AsForm() DeleteRequest request);

  @GetReq(path: "password_reset.php")
  Future<dynamic> resetPassword();

  @PostReq(path: "password_reset.php")
  Future<dynamic> resetPasswordRequest(@AsForm() ResetPasswordForm request);

  @GetReq(path: "report_send.php")
  Future<dynamic> sendEmailPage();

  @PostReq(path: "report_send.php")
  Future<dynamic> sendEmail(@AsForm() SendEmailForm request);
}