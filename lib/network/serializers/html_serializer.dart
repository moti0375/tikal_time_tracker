import 'package:jaguar_serializer/src/serializer/serializer.dart';


class HtmlSerializer extends Serializer<String>{
  @override
  String fromMap(Map map) {
    String str = map["<html>"];
    return str;
  }

  @override
  Map<String, String> toMap(String model) {
    print("form serializer: toMap: ${model.toString()}");
    Map<String, String> map;
    return map;
  }

}