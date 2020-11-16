import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jaguar_retrofit/annotations/params.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/network/credentials.dart';
import 'package:tikal_time_tracker/network/requests/delete_request.dart';
import 'package:tikal_time_tracker/network/requests/login_request.dart';
import 'package:tikal_time_tracker/network/requests/reports_form.dart';
import 'package:tikal_time_tracker/network/requests/reset_password_form.dart';
import 'package:tikal_time_tracker/network/requests/send_email_form.dart';
import 'package:tikal_time_tracker/network/requests/update_request.dart';
import 'package:tikal_time_tracker/utils/utils.dart';
import 'package:client_cookie/client_cookie.dart';

class DioNetworkAdapter {
  static const TAG = "DioNetworkAdapter";

  static const BASE_URL = "https://planet.tikalk.com/timetracker";
  final Dio dio;

  DioNetworkAdapter._internal({this.dio}) {
    List<ClientCookie> cookies = List<ClientCookie>();

    dio.interceptors.add(InterceptorsWrapper(onRequest: (options) {
      print("onRequest: ${options.headers.toString()}");
      print("onRequest: extra: ${options.extra}");
      print("onRequest: data ${options.data.toString()}");
    }, onError: (e) {
      print("Something went wrong: ${e.toString()}");
    }, onResponse: (Response response) {
      print("$TAG onResponse headers: ${response.headers.toString()}");


      List<String> cookieHeader = response.headers['set-cookie'];
      // String cookieStr = map["set-cookie"];

      if (cookieHeader != null) {
        print("There are Cookies: $cookieHeader");

        cookies.clear();
        cookieHeader.forEach((element) {
          cookies.addAll(Utils.cookies(element));
        });

        print("$TAG, cookies: ${cookies.toString()}");
        dio.options.headers[HttpHeaders.cookieHeader] = cookies;
      }

      return response;
    }));
  }

  factory DioNetworkAdapter.create() {
    BaseOptions options = BaseOptions(baseUrl: BASE_URL);
    options.followRedirects = false;
    options.validateStatus = (status) { return status < 400; };
    Dio dio = Dio(options);
    return DioNetworkAdapter._internal(dio: dio);
  }

  void updateAuthHeader(Credentials credentials) {
    print("TimeTrackerApi: updateAuthHeader ${credentials.toString()}");
    List<int> utf8Convert = Utf8Encoder().convert("${credentials.signInUserName}:${credentials.signInPassword}");
    dio.options.headers[HttpHeaders.authorizationHeader] = "Basic ${Base64Encoder().convert(utf8Convert)}";
  }

  Future<dynamic> signIn() async {
    Response<dynamic> response = await dio.get('/login.php');
    return response.data;
  }

  Future<dynamic> login(LoginForm loginForm) async {
    FormData formData = FormData.fromMap(loginForm.toMap());
    print("$TAG, login: form: ${formData.toString()}");
    try {
      Response<dynamic> response = await dio.post('/login.php', data: formData);
      print("$TAG: LoginResponse: ${response.data}");
      return response.data;
    } catch (e) {
      print("$TAG error: ${e.toString()}");
      if(e is DioError && e.response.statusCode == 302){
        return "";
      } else {
        throw e;
      }
    }
  }

  Future<dynamic> time() async {
    Response<dynamic> response = await dio.get('/time.php');
    return response.data;
  }

  Future<dynamic> timeForDate( String dateStr) async {
    Response<dynamic> response = await dio.get('/time.php', queryParameters: {'date': dateStr });
    return response.data;
  }

  Future<dynamic> addTime( TimeRecord timeRecord) async {
    FormData formData = FormData.fromMap(timeRecord.toMap());
    Response<dynamic> response = await dio.post('/time.php', data: formData);
    return response.data;
  }

  Future<dynamic> deleteTime(int id, DeleteRequest request) async {
    FormData formData = FormData.fromMap(request.toMap());
    Response<dynamic> response = await dio.post("/time_delete.php", queryParameters: {"id": id}, data: formData);
    return response.data;
  }

  Future<dynamic> updateTime(int id, UpdateRequest request) async {
    FormData formData = FormData.fromMap(request.toMap());
    Response<dynamic> response = await dio.post("/time_edit.php", data: formData, queryParameters: {"id": id});
    return response.data;
  }

  Future<dynamic> users() async {
    Response<dynamic> response = await dio.get("/users.php");
    return response.data;
  }

  Future<dynamic> reports() async {
    Response<dynamic> response = await dio.get("/reports.php");
    return response.data;
  }

  Future<dynamic> generateReport( ReportForm request) async {
    FormData formData = FormData.fromMap(request.toMap());
    Response<dynamic> response = await dio.post("/reports.php", data: formData);
    return response.data;
  }

  Future<dynamic> getReport() async {
    Response<dynamic> response = await dio.post('/report.php');
    return response.data;
  }

  Future<dynamic> getIncompleteRecordById(int id) async {
    Response<dynamic> response = await dio.get("/time_edit.php", queryParameters: {"id": id});
    return response.data;
  }

  Future<dynamic> resetPassword() async {
    Response<dynamic> response = await dio.get("/password_reset.php");
    return response.data;
  }

  Future<dynamic> resetPasswordRequest(ResetPasswordForm request) async {
    FormData formData = FormData.fromMap(request.toMap());
    Response<dynamic> response = await dio.post('/password_reset.php', data: formData);
    return response.data;
  }

  Future<dynamic> sendEmailPage() async {
   Response<dynamic> response = await dio.get('/report_send.php');
   return response.data;
  }

  Future<dynamic> sendEmail(@AsForm() SendEmailForm request) async {
    FormData formData = FormData.fromMap(request.toMap());
    Response<dynamic> response = await dio.post('/report_send.php', data: formData);
    return response.data;
  }
}
