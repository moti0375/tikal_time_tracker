import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';

class UsersBloc {

  final TimeRecordsRepository repository;
  UsersBloc({this.repository});
  Stream<List<Member>> loadUsers(User user) {
     return repository.getAllMembers(user.role);
  }
}