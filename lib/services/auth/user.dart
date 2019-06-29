import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/dom/dom_parser.dart';


class User {
   String name;
   Role role;
   String company;
   List<Project> projects;
   List<Task> tasks;

  static User _me;
  static User get me => _me;

  DomParser parser = DomParser();

  static User init(String dom)  {
    if (_me == null) {
      User._internal(dom);
    }
    return _me;
//    print("User: init ${me.toString()}");
  }

  static void signOut(){
    if(_me != null){
      _me = null;
    }
  }
  User._internal(String dom){
    print("User: internal");
    _me = parser.getUserFromDom(dom);
  }

  User({this.name, this.role, this.company, this.projects, this.tasks});

  factory User.builder(String name, Role role, String company, List<Project> projects, List<Task> tasks){
    print("User.builder: projects: ${projects.toString()}, ${tasks.toString()}");
    return new User(name: name, role: role, company: company, projects: projects, tasks: tasks);
  }

   @override
   String toString() {
     return 'User{name: $name, role: $role, company: $company, projects: $projects, tasks: $tasks}';
   }
}
