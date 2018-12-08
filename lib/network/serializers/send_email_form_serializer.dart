import 'package:jaguar_serializer/src/serializer/serializer.dart';
import 'dart:convert';
import 'package:tikal_time_tracker/network/requests/send_email_form.dart';
import 'package:intl/intl.dart';

class SendEmailSerializer extends Serializer<SendEmailForm> {

  @override
  SendEmailForm fromMap(Map map) {
    print("fromMap: ${map.toString()}");
    return  SendEmailForm(to: map["receiver"], cc: map["cc"], subject: map["subject"], comment: map["comment"]);
  }

  @override
  Map<String, String> toMap(SendEmailForm requestForm) {
    Map<String, String> map = Map<String, String>();
    map["receiver"] = requestForm.to;
    map["cc"] = requestForm.cc;
    map["subject"] = requestForm.subject;
    map["comment"] = requestForm.comment;
    map["btn_send"] = "Send";
    return map;
  }

}