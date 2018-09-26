

class LoginForm{
  String Login;
  String Password;
  LoginForm({this.Login, this.Password});

  @override
  String toString() {
    return 'Form{Login: $Login, Password: $Password}';
  }
}

class FormRequest{
  LoginForm form;
  FormRequest({this.form});
}