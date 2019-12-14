class LogInModel {
  bool loggingIn;
  bool obscured;
  String email;
  String password;
  String errorInfo;

  LogInModel(
      {this.loggingIn = false,
      this.obscured = true,
      this.email,
      this.password,
      this.errorInfo});

  LogInModel updateWith(
  {bool loggingIn,
    String email,
    String password,
    bool obscured,
    String errorInfo}
  ) {
    this.loggingIn = loggingIn ?? this.loggingIn;
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.obscured = obscured ?? this.obscured;
    this.errorInfo = errorInfo ?? this.errorInfo;
    return this;
  }

  void toggleObscure(){
    updateWith(obscured: !this.obscured);
  }
}
