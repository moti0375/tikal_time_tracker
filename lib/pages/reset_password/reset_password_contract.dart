import 'package:tikal_time_tracker/pages/mvp_base.dart';
class ResetPasswordBasePresenter extends BasePresenter{
  void onResetPasswordButtonClicked(String login){}
}

class ResetPasswordBaseView extends BaseView{
  void showResultStatus(String status){}
  void handleError(){}
  void logOut(){}
}