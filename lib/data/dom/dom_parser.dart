import 'package:html/dom.dart' as DomText;
import 'package:html/dom.dart' show Document;
import 'package:html/dom.dart' as DomElement;
import 'package:html/parser.dart' show parse;
import '../user.dart';
import '../project.dart';
import '../task.dart';
import '../models.dart';
import '../member.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
class DomParser {
  static const String TAG = "DomParser";

  DomParser() {}

  DateFormat timeFormat = DateFormat('H:m');

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

    Map<int, List<int>> tasksForProjects = _extractTasksForProjects(
        domStr, projects);

//    debugPrint("_extractTasks: $domStr");

    projects.forEach((p) {
      print("getUserFromDom: p = ${p.name}:${tasksForProjects[p.value]}");
      List<Task> tasksForProj = tasksForProjects[p.value].map((t) {
        Task task = tasks.firstWhere((e) {
          print("firstWhere: $t -> ${e.value}:${e.name}");
          return (e.value == t);
        });
        return task;
      }).toList();
      print("getUserFromDom: tasksForProj ${p.name} : ${tasksForProj
          .toString()}");
      p.tasks = tasksForProj;
    });

    print("getUserFromDom: ${projects.toString()}");
    return projects;
  }

  List<Project> _extractProjects(String domStr) {
    String firstDelimiter = "var projects = new Array();";
    String secondDelimiter = "// Prepare an array of task ids for projects";
    String buffer = domStr.substring(
        domStr.indexOf(firstDelimiter) + firstDelimiter.length,
        domStr.indexOf(secondDelimiter));

    List<String> projects = buffer.split("projects[idx] = new Array(");

    projects.removeAt(0);

    projects = projects.map((it) {
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

  Map<int, List<int>> _extractTasksForProjects(String domStr,
      List<Project> projects) {
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


  List<TimeRecord> parseTimePage(String timeDomStr) {
    String start = "<table border=\"0\" cellpadding=\"3\" cellspacing=\"1\" width=\"100%\">";
    String stop = "</table>";
    String buffer = timeDomStr.substring(
        timeDomStr.indexOf(start) + start.length);
    buffer = buffer.substring(0, buffer.indexOf(stop));

//    debugPrint("parseTimePage $timeDomStr");


    DateTime date = _extractDateTime(timeDomStr);

    List<String> rows = buffer.trim().split("<tr");
    rows.removeAt(0);
    rows.removeAt(0);

    rows = rows.map((r) {
      return r.substring(r.indexOf(">") + 1, r.indexOf("</tr>"));
    }).toList();

//    debugPrint("rows: ${rows.toString()}, size: ${rows.length}");

    List<TimeRecord> result = rows.map((row) {
      List<String> cells = row.split("</td>");

      cells = cells.map((it) {
        return it.substring(it.indexOf(">") + 1);
      }).toList();
//     debugPrint("cells: ${cells.toString()}, size: ${cells.length}");

      Task task = User.me.tasks.firstWhere((it) {
//        print("firstWhere: ${it.name}:${cells[1]}");
        return it.name == cells[1];
      });

      TimeOfDay start = TimeOfDay.fromDateTime(timeFormat.parse(cells[2]));
      TimeOfDay finish = null;

      try{
        finish = TimeOfDay.fromDateTime(timeFormat.parse(cells[3]));
      }
      catch(e){
        if(e is FormatException){
          finish = null;
        }
      }

//      .substring(cells[6].indexOf("id=")+1, cells[6].indexOf("\">"))
      int trackerId = int.parse(cells[6].substring(cells[6].indexOf("id=")+3, cells[6].indexOf("\">")).trim());
      print("trackerId: $trackerId");

      Project project = User.me.projects.firstWhere((it){
        return it.name == cells[0];
      });

      return TimeRecord(id: trackerId, project: project,
          task: task,
          start: start,
          date: date,
          finish: finish,
          comment: cells[5].trim().replaceAll("&nbsp;", ""));
    }).toList();
    return result;
  }


  DateTime _extractDateTime(String domStr) {
    String pageTitleStart = "<!-- page title and user details -->";
    String pageTitleEnd = "<!-- end of page title and user details -->";

    String timeStr = domStr.substring(
        domStr.indexOf(pageTitleStart) + pageTitleStart.length);
    timeStr = timeStr.substring(0, timeStr.indexOf(pageTitleEnd));

    timeStr = timeStr.substring(
        timeStr.indexOf("Time: ") + 6, timeStr.indexOf("</div>"));
//    print("_extractDateTime: $timeStr");
    DateFormat formatter = DateFormat("y-MM-d");
    return formatter.parse(timeStr.trim());
  }



  List<Member> parseUsersPage(String domStr){

    String start = "<table cellspacing=\"1\" cellpadding=\"3\" border=\"0\" width=\"100%\">";
    String end = "</table>";

    String buffer = domStr.substring(domStr.indexOf(start) + start.length);
    buffer = buffer.substring(0, buffer.indexOf(end));

    List<String> rows = buffer.split("</tr>");
    rows.removeAt(0);
    rows.removeLast();

    List<Member> members = rows.map((r){
      List<String> cells = r.substring(r.indexOf("<td>")).split("</td>");
      cells = cells.map((cell){
        return cell.substring(cell.indexOf("<td>") + 4);
      }).toList();

      cells.removeLast();
      return Member(name: cells[0], email: cells[1], role: cells[2]);
    }).toList();

   // print("members: ${members.toString()}");
    return members;
  }


  List<TimeRecord> parseReportPage(String domStr){
   // print("parseReportPage: $domStr");
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formStart = "<form name=\"reportForm\" method=\"post\">";
    String formEnd = "</form>";
    String reportStart = "-- normal report -->";
    String reportEnd = "</table>";
    String buffer = domStr.substring(domStr.indexOf(formStart)+formStart.length, domStr.indexOf(formEnd));
//    debugPrint("parseReportPage: $buffer");

    buffer = buffer.substring(buffer.indexOf(reportStart) + reportStart.length);
    buffer = buffer.substring(0, buffer.indexOf(reportEnd));

    List<String> rows = buffer.split("</tr>");

    rows.removeAt(0);
    rows.removeLast();
    rows.removeLast();
    rows.removeLast();

    List<TimeRecord> records = rows.map((row){
      List<String> cells = row.substring(row.indexOf("<td ")).split("</td>");
      cells.removeLast();
      cells = cells.map((cell){
        cell = cell.substring(cell.indexOf("<td") + 3);
        return cell.substring(cell.indexOf(">") + 1);
      }).toList();

//      print("parseReportPage: ${cells.toString()}");

      DateTime dateTime = dateFormat.parse(cells[0]);
      Project project = User.me.projects.firstWhere((it){
        return it.name == cells[1];
      });

      Task task = User.me.tasks.firstWhere((it){
        return it.name == cells[2];
      });

      TimeOfDay start = TimeOfDay.fromDateTime(timeFormat.parse(cells[3]));
      TimeOfDay finish = null;

      try{
        finish = TimeOfDay.fromDateTime(timeFormat.parse(cells[4]));
      }
      catch(e){
        if(e is FormatException){
          finish = null;
        }
      }
      return TimeRecord(date: dateTime, project: project, task: task, start: start, finish: finish, comment: cells[6].trim().replaceAll("&nbsp;", ""));
    }).toList();

//    print("parseReportPage: ${records.toString()}");
    return records;
  }
}
