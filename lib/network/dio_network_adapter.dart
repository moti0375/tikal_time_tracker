import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/network/client_cookie.dart';
import 'package:tikal_time_tracker/network/credentials.dart';
import 'package:tikal_time_tracker/network/endpoints.dart';
import 'package:tikal_time_tracker/network/requests/delete_request.dart';
import 'package:tikal_time_tracker/network/requests/login_request.dart';
import 'package:tikal_time_tracker/network/requests/reports_form.dart';
import 'package:tikal_time_tracker/network/requests/reset_password_form.dart';
import 'package:tikal_time_tracker/network/requests/send_email_form.dart';
import 'package:tikal_time_tracker/network/requests/update_request.dart';
import 'package:tikal_time_tracker/utils/utils.dart';

class DioNetworkAdapter {
  static const TAG = "DioNetworkAdapter";

  static const BASE_URL = "https://planet.tikalk.com/timetracker";
  final Dio dio;

  factory DioNetworkAdapter.create() {
    BaseOptions options = BaseOptions(baseUrl: BASE_URL);
    options.followRedirects = false;
    options.validateStatus = (status) { return status < 400; };
    Dio dio = Dio(options);
    return DioNetworkAdapter._internal(dio: dio);
  }

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

  Future<dynamic> _executeGetRequest({String endpoint, Map<String, dynamic> params, Options options}) async {
    Response<dynamic> response = await dio.get(endpoint, queryParameters: params, options: options);
    return response.data;
  }

  Future<dynamic> _executePostRequest({String endpoint, Map<String, dynamic> params, Options options, FormData data}) async {
    Response<dynamic> response = await dio.post(endpoint, queryParameters: params, options: options, data: data);
    return response.data;
  }

  void updateAuthHeader(Credentials credentials) {
    print("TimeTrackerApi: updateAuthHeader ${credentials.toString()}");
    List<int> utf8Convert = Utf8Encoder().convert("${credentials.signInUserName}:${credentials.signInPassword}");
    dio.options.headers[HttpHeaders.authorizationHeader] = "Basic ${Base64Encoder().convert(utf8Convert)}";
  }

  Future<dynamic> signIn() async => _executeGetRequest(endpoint: Endpoints.login);
  Future<dynamic> login(LoginForm loginForm) async => _executePostRequest(endpoint: Endpoints.login, data: FormData.fromMap(loginForm.toMap()));
  Future<dynamic> time() async => _executeGetRequest(endpoint: Endpoints.time);
  Future<dynamic> timeForDate( String dateStr) async =>  _executeGetRequest(endpoint: Endpoints.time, params: {'date': dateStr });
  Future<dynamic> addTime( TimeRecord timeRecord) async => _executePostRequest(endpoint: Endpoints.time, data: FormData.fromMap(timeRecord.toMap()));
  Future<dynamic> deleteTime(int id, DeleteRequest request) async => _executePostRequest(endpoint: Endpoints.time_delete, params: {"id": id}, data: FormData.fromMap(request.toMap()));
  Future<dynamic> updateTime(int id, UpdateRequest request) async => _executePostRequest(endpoint: Endpoints.time_edit, data: FormData.fromMap(request.toMap()), params: {"id": id});
  Future<dynamic> users() async => await _executeGetRequest(endpoint: Endpoints.users);
  Future<dynamic> reports() async => _executeGetRequest(endpoint: Endpoints.reports);
  Future<dynamic> generateReport( ReportForm request) async =>  _executePostRequest(endpoint: Endpoints.reports, data: FormData.fromMap(request.toMap()));
  Future<dynamic> getReport() async => _executePostRequest(endpoint: Endpoints.report);
  Future<dynamic> getIncompleteRecordById(int id) async => _executeGetRequest(endpoint: Endpoints.time_edit, params: {"id": id});
  Future<dynamic> resetPassword() async =>  _executeGetRequest(endpoint: Endpoints.reset_password);
  Future<dynamic> resetPasswordRequest(ResetPasswordForm request) async => _executePostRequest(endpoint: Endpoints.reset_password, data: FormData.fromMap(request.toMap()));
  Future<dynamic> sendEmailPage() async => _executeGetRequest(endpoint: Endpoints.send_report);
  Future<dynamic> sendEmail(SendEmailForm request) async => _executePostRequest(endpoint: Endpoints.send_report, data: FormData.fromMap(request.toMap()));

}
