import 'package:jaguar_serializer/src/serializer/serializer.dart';
import '../requests/login_request.dart';

class FormSerializer extends Serializer<Form>{
  @override
  Form fromMap(Map map) {
    return new Form(login: map['login'], password: map['password']);
  }

  @override
  Map<String, String> toMap(Form model) {
    print("form serializer: toMap: ${model.toString()}");
    Map<String, String> map;
    map['login'] = model.login;
    map['password'] = model.password;
    return map;
  }

}