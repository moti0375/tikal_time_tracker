import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/utils/formatters.dart';
import 'package:tikal_time_tracker/utils/utils.dart';
class UpdateRequest{
  final TimeRecord timeRecord;

  UpdateRequest({this.timeRecord});

  Map<String, String> toMap() {
    print("form serializer: toMap: ${this.toString()}");
    Map<String, String> map = Map<String, String>();


    map["id"] = "${this.timeRecord.id}";
    map["time_field_5"] = "${this.timeRecord.remote.value}";
    map["project"] = "${this.timeRecord.project.value}";
    map["task"] = "${this.timeRecord.task.value}";
    map["date"] = "${dateFormat.format(this.timeRecord.date)}";
    map["start"] = Utils.buildTimeStringFromTime(this.timeRecord.start);
    map["finish"] = this.timeRecord.finish == null ? "" : Utils.buildTimeStringFromTime(this.timeRecord.finish);
    map["duration"] = "";
    map["note"] = this.timeRecord.comment;
    map["btn_save"] = "Save";
    map["browser_today"] = "${dateFormat.format(DateTime.now())}";
    return map;
  }
}