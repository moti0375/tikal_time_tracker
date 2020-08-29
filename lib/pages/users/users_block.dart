import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';

class UsersBloc {

  final TimeRecordsRepository repository;
  final BaseAuth auth;
  UsersBloc({this.repository, this.auth});
  Stream<List<Member>> loadUsers() {
     return repository.getAllMembers(auth.getCurrentUser().role);
  }
}