import 'task.dart';

class Project{
  String name;
  int value;
  List<Task> tasks;

  Project({this.name, this.value, this.tasks});

  @override
  String toString() {
    return 'Project{name: $name, value: $value, tasks: $tasks}';
  }
}