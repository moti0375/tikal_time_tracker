import 'package:jaguar_serializer/src/serializer/serializer.dart';
import 'package:intl/intl.dart';
import 'package:tikal_time_tracker/network/requests/delete_request.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/utils/utils.dart';

class DeleteRequestSerializer extends Serializer<DeleteRequest>{

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  @override
  DeleteRequest fromMap(Map map) {
    return new DeleteRequest(timeRecord: TimeRecord.empty());
  }

  @override
  Map<String, String> toMap(DeleteRequest model) {
    print("form serializer: toMap: ${model.toString()}");
    Map<String, String> map = Map<String, String>();

    map["id"] = "${model.timeRecord.id}";
    map["date"] = dateFormat.format(model.timeRecord.date);
    map["duration"] = Utils.buildTimeStringFromDuration(model.timeRecord.duration);
    map["comment"] = model.timeRecord.comment;
    map["delete_button"] = "Delete";
    map["browser_today"] = "${dateFormat.format(DateTime.now())}";
    return map;

  }

}