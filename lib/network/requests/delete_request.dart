import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/utils/formatters.dart';
import 'package:tikal_time_tracker/utils/utils.dart';
class DeleteRequest{
  final TimeRecord timeRecord;

  DeleteRequest({this.timeRecord});

  Map<String, String> toMap() {
    print("form serializer: toMap: ${this.toString()}");
    Map<String, String> map = Map<String, String>();

    map["id"] = "${this.timeRecord.id}";
    map["date"] = dateFormat.format(this.timeRecord.date);
    map["duration"] = Utils.buildTimeStringFromDuration(this.timeRecord.duration);
    map["comment"] = this.timeRecord.comment;
    map["delete_button"] = "Delete";
    map["browser_today"] = "${dateFormat.format(DateTime.now())}";
    return map;
  }

}