import 'users_contract.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';

class UsersPresenter implements MembersPresenterContract{


  TimeRecordsRepository repository;
  MembersViewContract view;

  UsersPresenter({this.repository});

  @override
  void loadUsers() {
    view.setLoadingIndicator(true);
    repository.getAllMembers().then((response){
      print("loadUsers: ${response.toString()}");
      view.setLoadingIndicator(false);
      view.showMembers(response);
    },onError: (e){
      view.setLoadingIndicator(false);
    });
  }

  @override
  void subscribe(MembersViewContract view) {
    this.view = view;
    loadUsers();
  }

}