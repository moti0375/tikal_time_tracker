import 'package:flutter/cupertino.dart';

abstract class LoginPageEvent{}
class LoginButtonClicked extends LoginPageEvent{
  BuildContext context;
  LoginButtonClicked({@required this.context});
}

class ForgotPasswordClicked extends LoginPageEvent{
   BuildContext context;
   ForgotPasswordClicked({@required this.context});
}

class UserName extends LoginPageEvent{
  final String userName;
  UserName({@required this.userName});
}

class Password extends LoginPageEvent{
  final String password;
  Password({@required this.password});
}

class ToggleObscureMode extends LoginPageEvent{}
class SignOut extends LoginPageEvent{}