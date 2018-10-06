import 'package:jaguar_serializer/src/serializer/serializer.dart';
import 'package:intl/intl.dart';
import '../requests/id_request.dart';
import '../../utils/utils.dart';

class IdRequestSerializer extends Serializer<IdRequest>{

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  @override
  IdRequest fromMap(Map map) {
    return new IdRequest(id: 0);
  }

  @override
  Map<String, String> toMap(IdRequest model) {
    print("form serializer: toSap: ${model.toString()}");
    Map<String, String> map = Map<String, String>();

    map["id"] = "${model.id}";
    map["browser_today"] = "${dateFormat.format(DateTime.now())}";
    return map;

  }

}