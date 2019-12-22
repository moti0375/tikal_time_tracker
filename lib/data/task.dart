import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Task extends Equatable{
  String name;
  int value;

  Task({this.name, this.value});

  @override
  String toString() {
    return 'Task{name: $name, value: $value}';
  }

  @override
  List<Object> get props => [name, value];
}