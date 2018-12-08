import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/data/models.dart';
class Member{
  final String name;
  final String email;
  final Role role;
  String id;
  int value;
  bool checked = true;
  bool hasIncompleteEntry = false;

  Member({this.name, this.email, this.role, this.id, this.value, this.hasIncompleteEntry});


  @override
  String toString() {
    return 'Member{name: $name, email: $email, role: $role, id: $id, value: $value, checked: $checked, hasIncompleteEntry: $hasIncompleteEntry}';
  }

  String toJson(){
    return '{id: ${id.split("_").last}, name: $name}';
  }


}