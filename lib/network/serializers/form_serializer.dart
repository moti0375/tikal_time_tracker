import 'package:jaguar_serializer/src/serializer/serializer.dart';
import 'package:tikal_time_tracker/network/requests/login_request.dart';

class FormSerializer extends Serializer<LoginForm>{
  @override
  LoginForm fromMap(Map map) {
    return new LoginForm(login: map['login'], password: map['password']);
  }

  @override
  Map<String, String> toMap(LoginForm model) {
    print("form serializer: toSap: ${model.toString()}");
    Map<String, String> map = Map<String, String>();
    map["login"] = model.login;
    map["password"] = model.password;
    return map;
  }

}