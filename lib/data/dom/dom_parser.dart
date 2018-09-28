import 'package:html/dom.dart' as DomText;
import 'package:html/dom.dart' show Document;
import 'package:html/dom.dart' as DomElement;
import 'package:html/parser.dart' show parse;
import '../user.dart';
import '../project.dart';
import '../task.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class DomParser {
  static const String TAG = "DomParser";

  DomParser() {}

  User getUserFromDom(String domStr) {
    String pageTitle = domStr.substring(
        domStr.indexOf("<!-- page title and user details -->"),
        domStr.indexOf("<!-- end of page title and user details -->"));
    print("$TAG: pageTitle: $pageTitle");
    String userDetails = pageTitle.substring(
        pageTitle.indexOf("<tr><td>") + 8, pageTitle.indexOf('</table>') - 19);
    String name = userDetails.substring(0, userDetails.indexOf(" - "));
    String role = userDetails.substring(
        userDetails.indexOf(" - ") + 3, userDetails.indexOf(", "));
    String company = userDetails.substring(userDetails.indexOf(", ") + 1);
    print("$TAG: name: $name, role: $role, company: $company");
    List<Task> tasks = _extractTasks(domStr);
    List<Project> projects = _extractProjectsForUser(domStr, tasks);
    return User.builder(name, role, company, projects, tasks);
  }

  List<Project> _extractProjectsForUser(String domStr, List<Task> tasks) {

    List<Project> projects = _extractProjects(domStr);

    Map<int, List<int>> tasksForProjects = _extractTasksForProjects(domStr, projects);

//    debugPrint("_extractTasks: $domStr");

    projects.forEach((p){
      print("getUserFromDom: p = ${p.name}:${tasksForProjects[p.value]}");
      List<Task> tasksForProj = tasksForProjects[p.value].map((t){
         Task task = tasks.firstWhere((e){
           print("firstWhere: $t -> ${e.value}:${e.name}");
          return (e.value == t);
        });
         return task;
      }).toList();
      print("getUserFromDom: tasksForProj ${p.name} : ${tasksForProj.toString()}" );
      p.tasks = tasksForProj;
    });

    print("getUserFromDom: ${projects.toString()}");
    return projects;
  }

  List<Project> _extractProjects(String domStr){
    String firstDelimiter = "var projects = new Array();";
    String secondDelimiter = "// Prepare an array of task ids for projects";
    String buffer = domStr.substring(domStr.indexOf(firstDelimiter)+firstDelimiter.length, domStr.indexOf(secondDelimiter));

    List<String> projects = buffer.split("projects[idx] = new Array(");

    projects.removeAt(0);

    projects = projects.map((it){
      return it.substring(0, it.indexOf("\");"));
    }).toList();

    print("_extractProjects: ${projects.toString()}");

    List<Project> result = projects.map((projectStr) {
      String container = projectStr.replaceAll("\"", "");
      List<String> m = container.split(",");
      print("${m[0].trim()}:${m[1].trim()}");
      String name = m[1].trim();
      String value = m[0].trim();

      int val = int.tryParse(value);

      return Project(name: name, value: val);
    }).toList();
    print("_extractProjects result: ${result.toString()}");
    return result;
  }

  List<Task> _extractTasks(String domStr) {
    String startBuffer = "var task_names = new Array();";
    String endBuffer = "// Mandatory top options";
    String tasksStart = domStr.substring(
        domStr.indexOf(startBuffer) + startBuffer.length + 1,
        domStr.indexOf(endBuffer));
    List<String> tasksList = tasksStart.split(";");

//    debugPrint("_extractTasks: $domStr" );
    tasksList.removeLast();

    List<Task> tasks = tasksList.map((taskStr) {
      String delimiter = "[";
      int value = int.tryParse(taskStr.substring(
          taskStr.indexOf(delimiter) + 1, taskStr.indexOf("]")));
      String name = taskStr
          .replaceAll("\"", "")
          .substring(taskStr.indexOf("= ") + 2)
          .trim();
      return Task(name: name, value: value);
    }).toList();
    print("_extractTasks: ${tasks.toString()}");
    return tasks;
  }

  Map<int, List<int>> _extractTasksForProjects(
      String domStr, List<Project> projects) {
    String startDelimiter = "var task_ids = new Array()";
    String endDelimiter = "// Prepare an array of task names.";

    String container = domStr.substring(
        domStr.indexOf(startDelimiter) + startDelimiter.length,
        domStr.indexOf(endDelimiter));
//    print("_extractTasksForProjects: container $container");

    List<String> l = container.split(";");
    l.removeAt(0);
    l.removeLast();
//    print("_extractTasksForProjects: $l");

    Map<int, List<int>> projectsAndTasks = Map<int, List<int>>();
    l.forEach((it) {
//      print("_extractTasksForProjects: ${it.substring(it.indexOf("[") + 1, it.indexOf("]"))}");
      int prjVal =
      int.tryParse(it.substring(it.indexOf("[") + 1, it.indexOf("]")));
      List<int> tasks = it
          .substring(it.indexOf(" = ") + 3)
          .replaceAll("\"", "")
          .split(",")
          .map((it) {
        return int.tryParse(it.trim());
      }).toList();

      tasks.remove(14); //There is no task 14
//      print("_extractTasksForProjects: tasks ${tasks.toString()}");

      projectsAndTasks[prjVal] = tasks;
    });

    print("_extractTasksForProjects ${projectsAndTasks.toString()}");
    return projectsAndTasks;
  }
}
