import 'package:tikal_time_tracker/pages/mvp_base.dart';
import 'package:tikal_time_tracker/pages/send_email/send_email_contract.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/network/requests/send_email_form.dart';

class SendEmailPresenter implements SendMailContractPresenter{

  static const String TAG = "SendEmailPresenter:";
  TimeRecordsRepository repository;

  SendEmailPresenter({this.repository});
  SendMailContractView view;

  String toText;
  String ccText;
  String commentText;
  String subjectText;

  @override
  void subscribe(BaseView view) {
    this.view = view;
    _loadSendEmailPage();
  }

  @override
  void unsubscribe() {
    // TODO: implement unsubscribe
  }

  @override
  void onToInputTextChanged(String toText) {
    print("$TAG onToInputTextChanged: $toText");
    this.toText = toText;
  }

  @override
  void onCcInputTextChanged(String ccText) {
    print("$TAG onCcInputTextChanged: $ccText");
    this.ccText = ccText;
  }

  @override
  void onCommentInputTextChanged(String commentText) {
    print("$TAG onCommentInputTextChanged: $commentText");
    this.commentText = commentText;
  }

  @override
  void onSubjectInputTextChanged(String subjectText) {
    print("$TAG onSubjectInputTextChanged: $subjectText");
    this.subjectText = subjectText;
  }

  @override
  void onSendMailButtonClicked() {
    _handleButtonClick();
  }

  void _handleButtonClick(){

    if((toText != null && toText.isNotEmpty) &&  (subjectText != null && subjectText.isNotEmpty)){
      SendEmailForm request = SendEmailForm(to: toText, cc: ccText, subject: subjectText, comment: commentText);
      repository.sendEmail(request).then((response){
        print("_handleButtonClick: $response");
        view.showSentStatus(response);
      }, onError: (e){
        _handleError(e);
      });
    }

  }

  void _loadSendEmailPage() {
    repository.sendEmailPage().then((form){
      print("_loadSendEmailPage: ${form.toString()}" );
      view.showPageDetails(form);
    }, onError: (e){
      _handleError(e);
    });
  }

  void _handleError(dynamic e){
    if(e is RangeError){
      print("${e.message}");
    }else{
      print(e);
      view.logOut();
    }
  }
}