import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/remote.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/data/models.dart';

class User extends Equatable{
  final String name;
  final Role role;
  final String company;
  final List<Project> projects;
  final List<Task> tasks;
  final List<Remote> remotes;

  User({
    @required this.name,
    @required this.role,
    @required this.company,
    @required this.projects,
    @required this.tasks,
    @required this.remotes,
  });

  @override
  List<Object> get props => [name, role, company, projects, tasks, remotes];

  @override
  bool get stringify => true;
}
