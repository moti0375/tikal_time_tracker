import 'package:flutter/material.dart';
import 'models.dart';


class User {
  final String name;
  final String role;
  final String company;
  final List<Project> projects;

  static User _instance;
  static User get instance => _instance;

  static void init(String name, String role, String company, List<Project> projects) {
    if (_instance == null) {
      _instance = User._internal(name, role, company, projects);
    }
  }

  User._internal(this.name, this.role, this.company, this.projects);

  factory User() {
    return _instance;
  }
}
