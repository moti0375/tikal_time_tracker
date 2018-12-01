import 'package:jaguar_serializer/src/serializer/serializer.dart';
import 'dart:convert';
import 'package:tikal_time_tracker/network/requests/reset_password_form.dart';
import 'package:intl/intl.dart';

class ResetPasswordSerializer extends Serializer<ResetPasswordForm> {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  @override
  ResetPasswordForm fromMap(Map map) {
    print("fromMap: ${map.toString()}");
    return  map["login"];
  }

  @override
  Map<String, String> toMap(ResetPasswordForm requestForm) {
    Map<String, String> map = Map<String, String>();
    map["login"] = requestForm.login;
    map["btn_submit"] = "Reset password";
    return map;
  }

}