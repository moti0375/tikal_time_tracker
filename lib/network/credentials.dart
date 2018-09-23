class Credentials{
  final String loginUserName;
  final String loginPassword;
  final String signInUserName;
  final String signInPassword;

  Credentials({this.loginUserName, this.loginPassword, this.signInUserName, this.signInPassword});

  @override
  String toString() {
    return 'Credentials{loginUserName: $loginUserName, loginPassword: $loginPassword, signInUserName: $signInUserName, signInPassword: $signInPassword}';
  }
}