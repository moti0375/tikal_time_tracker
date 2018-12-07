import 'package:tikal_time_tracker/pages/mvp_base.dart';
import 'package:tikal_time_tracker/pages/send_email/send_email_contract.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';

class SendEmailPresenter implements SendMailContractPresenter{

  TimeRecordsRepository repository;

  SendEmailPresenter({this.repository});

  String toText;
  String ccText;
  String commentText;
  String subjectText;

  @override
  void subscribe(BaseView view) {
    // TODO: implement subscribe
  }

  @override
  void unsubscribe() {
    // TODO: implement unsubscribe
  }

  @override
  void onToInputTextChanged(String toText) {
    this.toText = toText;
  }

  @override
  void onCcInputTextChanged(String ccText) {
    this.ccText = ccText;
  }

  @override
  void onCommentInputTextChanged(String commentText) {
    this.commentText = commentText;
  }

  @override
  void onSubjectInputTextChanged(String subjectText) {
    this.subjectText = subjectText;
  }

  @override
  void onSendMailButtonClicked() {
    _handleButtonClick();
  }

  void _handleButtonClick(){

  }
}