import 'package:tikal_time_tracker/data/name_value_entity.dart';

// ignore: must_be_immutable
class Task extends NameValueEntity{
  Task({String name, int value}) : super(name: name, value: value);

  @override
  List<Object> get props => [name, value];
  @override
  bool get stringify => true;
}