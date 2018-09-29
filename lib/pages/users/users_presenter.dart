import 'users_contract.dart';
import '../../data/repository/time_records_repository.dart';

class UsersPresenter implements MembersPresenterContract{


  TimeRecordsRepository repository;
  MembersViewContract view;

  UsersPresenter({this.repository});

  @override
  void loadUsers() {
    repository.getAllMembers().then((response){
      view.showMembers(response);
    },onError: (e){

    });
  }

  @override
  void subscribe(MembersViewContract view) {
    this.view = view;
    loadUsers();
  }

}