import 'package:tikal_time_tracker/pages/reset_password/reset_password_contract.dart';
import 'package:tikal_time_tracker/pages/mvp_base.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';

class ResetPasswordPresenter implements ResetPasswordBasePresenter{

  ResetPasswordBaseView view;
  final TimeRecordsRepository _repository;

  ResetPasswordPresenter(this._repository){

  }

  @override
  void subscribe(BaseView view) {
    this.view = view;
    _loadResetPasswordPage();
  }

  @override
  void unsubscribe() {
  }

  void _loadResetPasswordPage(){

  }
}