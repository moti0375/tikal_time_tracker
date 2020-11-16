class ResetPasswordForm{

  String login;
  ResetPasswordForm({this.login});

  Map<String, String> toMap() {
    Map<String, String> map = Map<String, String>();
    map["login"] = this.login;
    map["btn_submit"] = "Reset password";
    return map;
  }
}