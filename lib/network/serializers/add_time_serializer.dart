import 'package:jaguar_serializer/src/serializer/serializer.dart';
import 'package:intl/intl.dart';
import '../../data/models.dart';
import '../../utils/utils.dart';

class AddTimeSerializer extends Serializer<TimeRecord>{

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  @override
  TimeRecord fromMap(Map map) {
    return new TimeRecord.empty();
  }

  @override
  Map<String, String> toMap(TimeRecord model) {
    print("form serializer: toSap: ${model.toString()}");
    Map<String, String> map = Map<String, String>();

    map["project"] = "${model.project.value}";
    map["task"] = "${model.task.value}";
    map["date"] = "${model.date.toString()}";
    map["start"] = Utils.buildTimeStringFromTime(model.start);
    map["finish"] = model.finish == null ? "" : Utils.buildTimeStringFromTime(model.finish);
    map["duration"] = "";
    if(model.comment != null && model.comment.isNotEmpty){
      map["note"] = model.comment;
    }
    map["btn_submit"] = "Submit";
    map["browser_today"] = "${dateFormat.format(DateTime.now())}";
    return map;
  }

}