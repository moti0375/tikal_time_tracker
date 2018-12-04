import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/data/models.dart';
class Member{
  final String name;
  final String email;
  final Role role;
  String id;
  int value;
  bool checked = true;

  Member({this.name, this.email, this.role, this.id, this.value});

  @override
  String toString() {
    return '{name: $name, email: $email, role: $role, id: $id, value: $value}';
  }

  String toJson(){
    return '{id: ${id.split("_").last}, name: $name}';
  }


}