import 'package:tikal_time_tracker/data/name_value_entity.dart';

import 'task.dart';


// ignore: must_be_immutable
class Project extends NameValueEntity {
  List<Task> tasks;

  Project({String name, int value, this.tasks}) : super (name: name, value: value);

  @override
  List<Object> get props => [name, value, tasks];
}