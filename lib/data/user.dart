import 'package:flutter/material.dart';
import '../data/project.dart';
import '../data/task.dart';
import '../data/dom/dom_parser.dart';


class User {
   String name = "Shmulik";
   String role = "Cleaner";
   String company = "Tikal";
   List<Project> projects;
   List<Task> tasks;

  static User _me;
  static User get me => _me;

  DomParser parser = DomParser();

  static void init(String dom) {
    print("User: init");
    if (_me == null) {
      _me = User._internal(dom);
    }
  }

  User._internal(String dom){
    print("User: internal");
    parser.getUserFromDom(dom);
  }

  User({this.name, this.role, this.company, this.projects, this.tasks});

  factory User.builder(String name, String role, String company, List<Project> projects, List<Task> tasks){
    return new User(name: name, role: role, company: company, projects: projects, tasks: tasks);
  }
}
