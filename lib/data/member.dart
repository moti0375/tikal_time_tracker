import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/data/models.dart';
class Member{
  final String name;
  final String email;
  final Role role;

  Member({this.name, this.email, this.role});

  @override
  String toString() {
    return 'Member{name: $name, email: $email, role: $role}';
  }


}