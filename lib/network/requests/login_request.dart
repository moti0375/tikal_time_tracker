

class LoginForm{
  String login;
  String password;
  LoginForm({this.login, this.password});

  @override
  String toString() {
    return 'Form{Login: $login, Password: $password}';
  }

  Map<String, dynamic> toMap(){
    return {'login': login, 'password': password};
  }
}

class FormRequest{
  LoginForm form;
  FormRequest({this.form});
}