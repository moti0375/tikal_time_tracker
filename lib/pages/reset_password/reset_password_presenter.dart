import 'package:tikal_time_tracker/pages/reset_password/reset_password_contract.dart';
import 'package:tikal_time_tracker/pages/mvp_base.dart';
import 'package:tikal_time_tracker/network/requests/reset_password_form.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';

class ResetPasswordPresenter implements ResetPasswordBasePresenter{

  ResetPasswordBaseView view;
  TimeRecordsRepository repository;

  ResetPasswordPresenter({this.repository});

  @override
  void subscribe(BaseView view) {
    this.view = view;
    _loadResetPasswordPage();
  }

  @override
  void unsubscribe() {
  }

  void _loadResetPasswordPage(){
    print("_loadResetPasswordPage: ");
    repository.resetPasswordPage().then((response){

    }, onError: (e){
      print("There was an error");
    });
  }

  @override
  void onResetPasswordButtonClicked(String login) {
    _handleResetPasswordButtonClicked(login);
  }

  _handleResetPasswordButtonClicked(String login){
    print("onResetPasswordButtonClicked:");

    repository.resetPassword(ResetPasswordForm(login: login)).then((response){
      print("onResetPasswordButtonClicked: success");
      view.showResultStatus(response.toString());
    }, onError: (e){

    });
  }
}