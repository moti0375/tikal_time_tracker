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
}
