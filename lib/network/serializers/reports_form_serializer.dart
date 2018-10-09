import 'package:jaguar_serializer/src/serializer/serializer.dart';
import '../requests/reports_form.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class ReportsFormSerializer extends Serializer<ReportForm>{
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  @override
  ReportForm fromMap(Map map) {
    print("fromMap: ${map.toString()}");
    return ReportForm(project: map["project"]);
  }

  @override
  Map<String, String> toMap(ReportForm form) {
    print("form serializer: toMap: ${form.toString()}");
    Map<String, String> map = Map<String, String>();;
    map["start_date"] = dateFormat.format(form.startDate);
    map["end_date"] = dateFormat.format(form.endDate);
    map["project"] = "${form.project.value}";
    map["task"] = form.task == null ? "" : "${form.task.value}";
    map["period"] = "${form.period.value}";
    map["chduration"] = "1";
    map["chnote"] = "1";
    map["chclient"] = "1";
    map["chinvoice"] = "0";
    map["chpaid"] = "0";
    map["chip"] = "0";
    map["chcost"] = "0";
    map["chstart"] = "1";
    map["chfinish"] = "1";
    map["chproject"] = "1";
    map["chtask"] = "1";
    map["chtotalsonly"] = "0";
    map["chcf_1"] = "0";
    map["chunits"] = "0";
    map["fav_report_changed"] = "";
    map["btn_generate"] = "Generate";
    map["group_by"] = "no_grouping";

    return map;
  }

}