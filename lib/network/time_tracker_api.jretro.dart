// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_tracker_api.dart';

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$TimeTrackerApiClient implements ApiClient {
  final String basePath = "timetracker";
  Future<dynamic> signIn() async {
    var req = base.get.path(basePath).path("login.php");
    return serializers.from(await req.go().body);
  }

  Future<dynamic> login(LoginForm request) async {
    var req = base.post
        .metadata({
          "jar": true,
        })
        .path(basePath)
        .path("login.php")
        .urlEncodedForm(serializers.to(request));
    return serializers.from(await req.go().body);
  }

  Future<dynamic> time() async {
    var req = base.get.path(basePath).path("time.php");
    return serializers.from(await req.go().body);
  }

  Future<dynamic> timeForDate(String date) async {
    var req = base.get.path(basePath).path("time.php").query("date", date);
    return serializers.from(await req.go().body);
  }

  Future<dynamic> users() async {
    var req = base.get.path(basePath).path("users.php");
    return serializers.from(await req.go().body);
  }

  Future<dynamic> reports() async {
    var req = base.get.path(basePath).path("reports.php");
    return serializers.from(await req.go().body);
  }

  Future<dynamic> generateReport(ReportForm request) async {
    var req = base.post
        .path(basePath)
        .path("reports.php")
        .urlEncodedForm(serializers.to(request));
    return serializers.from(await req.go().body);
  }

  Future<dynamic> getReport() async {
    var req = base.post.path(basePath).path("report.php");
    return serializers.from(await req.go().body);
  }

  Future<dynamic> addTime(TimeRecord request) async {
    var req = base.post
        .path(basePath)
        .path("time.php")
        .urlEncodedForm(serializers.to(request));
    return serializers.from(await req.go().body);
  }

  Future<dynamic> updateTime(int id, UpdateRequest request) async {
    var req = base.post
        .path(basePath)
        .path("time_edit.php")
        .query("id", id)
        .urlEncodedForm(serializers.to(request));
    return serializers.from(await req.go().body);
  }

  Future<dynamic> timeDelete(int id, DeleteRequest request) async {
    var req = base.post
        .path(basePath)
        .path("time_delete.php")
        .query("id", id)
        .urlEncodedForm(serializers.to(request));
    return serializers.from(await req.go().body);
  }

  Future<dynamic> resetPassword() async {
    var req = base.get.path(basePath).path("password_reset.php");
    return serializers.from(await req.go().body);
  }
}
