import 'package:jaguar_serializer/src/serializer/serializer.dart';
import 'package:intl/intl.dart';
import '../../network/requests/update_request.dart';
import '../../data/models.dart';
import '../../utils/utils.dart';

class UpdateTimeSerializer extends Serializer<UpdateRequest>{

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  @override
  UpdateRequest fromMap(Map map) {
    return new UpdateRequest(timeRecord: TimeRecord.empty());
  }

  @override
  Map<String, String> toMap(UpdateRequest model) {
    print("form serializer: toSap: ${model.toString()}");
    TimeRecord timeRecord = model.timeRecord;
    Map<String, String> map = Map<String, String>();


    map["id"] = "${timeRecord.id}";
    map["project"] = "${timeRecord.project.value}";
    map["task"] = "${timeRecord.task.value}";
    map["date"] = "${dateFormat.format(timeRecord.date)}";
    map["start"] = Utils.buildTimeStringFromTime(timeRecord.start);
    map["finish"] = timeRecord.finish == null ? "" : Utils.buildTimeStringFromTime(timeRecord.finish);
    map["duration"] = "";
    map["note"] = timeRecord.comment;
    map["btn_save"] = "Save";
    map["browser_today"] = "${dateFormat.format(DateTime.now())}";
    return map;
  }

}