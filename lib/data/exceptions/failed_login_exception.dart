
class AppException implements Exception {
  final String cause;
  AppException({this.cause});
}

class IncompleteRecordException extends AppException{
  final int recordId;
  IncompleteRecordException({String cause, this.recordId}) : super(cause: cause);
}
