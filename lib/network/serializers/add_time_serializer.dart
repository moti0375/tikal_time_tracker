import 'package:jaguar_serializer/src/serializer/serializer.dart';
import 'package:intl/intl.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/utils/utils.dart';

class AddTimeSerializer extends Serializer<TimeRecord>{

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  @override
  TimeRecord fromMap(Map map) {
    return new TimeRecord.empty();
  }

  @override
  Map<String, String> toMap(TimeRecord model) {
    print("form serializer: toMap: ${model.toString()}");
    Map<String, String> map = Map<String, String>();

    map["project"] = "${model.project.value}";
    map["task"] = "${model.task.value}";
    map["date"] = "${dateFormat.format(model.date)}";
    map["start"] = Utils.buildTimeStringFromTime(model.start);
    map["finish"] = model.finish == null ? "" : Utils.buildTimeStringFromTime(model.finish);
    map["duration"] = "";
    if(model.comment != null && model.comment.isNotEmpty){
      map["note"] = model.comment;
    }
    map["time_field_5"] = "${model.remote.value}";
    map["btn_submit"] = "Submit";
    map["browser_today"] = "${dateFormat.format(DateTime.now())}";
    print("AddTimeSerializer serializer: map: ${map.toString()}");

    return map;
  }

}