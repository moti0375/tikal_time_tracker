import 'package:equatable/equatable.dart';

import 'task.dart';

// ignore: must_be_immutable
class Project extends Equatable {
  String name;
  int value;
  List<Task> tasks;

  Project({this.name, this.value, this.tasks});

  @override
  String toString() {
    return 'Project{name: $name, value: $value, tasks: $tasks}';
  }

  @override
  List<Object> get props => [name, value, tasks];
}