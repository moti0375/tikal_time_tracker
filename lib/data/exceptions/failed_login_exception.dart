
class FailedLoginException implements Exception {
  final String cause;
  FailedLoginException({this.cause});
}
