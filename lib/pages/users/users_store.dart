import 'package:mobx/mobx.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/users_event.dart';
import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';

part 'users_store.g.dart';

class UsersStore extends _UsersStore with _$UsersStore {
  UsersStore(TimeRecordsRepository repository, Analytics analytics) : super(repository, analytics);
}

abstract class _UsersStore with Store {
  final TimeRecordsRepository _repository;
  final Analytics _analytics;

  _UsersStore(this._repository, this._analytics);

  @observable
  List<Member> _users;
  List<Member> get users => _users;

  void loadUsers(User user) async {
    _repository.getAllMembers(user.role).then((value) {
      _analytics.logEvent(UsersEvent.impression(EVENT_NAME.LOAD_USERS_SUCCESS).setUser(user.name).view());
      _users = value;
    });
  }

  @action
  void initPage(){
    _analytics.logEvent(UsersEvent.impression(EVENT_NAME.USERS_SCREEN).open());
  }
}
