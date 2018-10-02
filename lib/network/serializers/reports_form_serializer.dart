import 'package:jaguar_serializer/src/serializer/serializer.dart';
import '../requests/reports_form.dart';
import 'dart:convert';

class ReportsFormSerializer extends Serializer<ReportForm>{
  @override
  ReportForm fromMap(Map map) {
    print("fromMap: ${map.toString()}");
    return ReportForm(project: map["project"]);
  }

  @override
  Map<String, String> toMap(ReportForm form) {
    print("form serializer: toSap: ${form.toString()}");
    Map<String, String> map = Map<String, String>();;
    map["start_date"] = "${form.startDate.year}-${form.startDate.month}-${form.startDate.day}";
    map["end_date"] = "${form.endDate.year}-${form.endDate.month}-${form.endDate.day}";
    map["period"] = "10";
    map["btn_generate"] = "Generate";

    return map;
  }

}