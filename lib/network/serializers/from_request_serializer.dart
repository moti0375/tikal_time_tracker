import 'package:jaguar_serializer/src/serializer/serializer.dart';
import 'package:tikal_time_tracker/network/requests/login_request.dart';


class FormRequestSerializer extends Serializer<FormRequest>{

  FormSerializer(){
    print("LoginSerializer: created" );
  }

  @override
  FormRequest fromMap(Map map) {
    print("fromMap was called");
    return FormRequest(form: new LoginForm(login: map['Login'], password: map['Password']));
  }

  @override
  Map<String, String> toMap(FormRequest model) {
    Map<String, String> form = Map<String, String>();
    form["form"] = "{Login : ${model.form.login}, Password : ${model.form.password}}";
//    print("toMap: ${form.toString()}" );
    return form;
  }




}