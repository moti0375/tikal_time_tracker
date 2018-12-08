import 'package:tikal_time_tracker/pages/mvp_base.dart';
import 'package:tikal_time_tracker/network/requests/send_email_form.dart';
class SendMailContractPresenter extends BasePresenter{
  void onToInputTextChanged(String toText){}
  void onCcInputTextChanged(String ccText){}
  void onSubjectInputTextChanged(String subjectText){}
  void onCommentInputTextChanged(String commentText){}
  void onSendMailButtonClicked(){}
}

class SendMailContractView extends BaseView{
  void showPageDetails(SendEmailForm form){}
  void showSentStatus(String status){}
  void logOut(){}
}