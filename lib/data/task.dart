class Task{
  String name;
  int value;

  Task({this.name, this.value});

  @override
  String toString() {
    return 'Task{name: $name, value: $value}';
  }
}