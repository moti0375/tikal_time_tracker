import 'package:jaguar_serializer/src/serializer/serializer.dart';
import '../requests/login_request.dart';


class FormRequestSerializer extends Serializer<FormRequest>{

  FormSerializer(){
    print("LoginSerializer: created" );
  }

  @override
  FormRequest fromMap(Map map) {
    print("fromMap was called");
    return FormRequest(form: new Form(login: map['login'], password: map['password']));
  }

  @override
  Map<String, String> toMap(FormRequest model) {
    Map<String, String> form = Map<String, String>();
    form["form"] = "{login : ${model.form.login}, password : ${model.form.password}}";
//    print("toMap: ${form.toString()}" );
    return form;
  }




}