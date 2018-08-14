import 'package:flutter/material.dart';
import '../data/database/database_helper.dart';

class User{
  String name;
  String login;
  Role role;

  User({this.name, this.login, this.role});
}

class TimeRecord{
  int id;
  String project;
  String task;
  TimeOfDay start;
  TimeOfDay finish;
  Duration duration;
  DateTime dateTime;
  String comment;

  TimeRecord({this.id, this.project, this.task, this.start, this.finish,
      this.dateTime, this.comment, this.duration}){
    DateTime s  = DateTime(dateTime.year, dateTime.month, dateTime.day, start.hour, start.minute);
    DateTime f  = DateTime(dateTime.year, dateTime.month, dateTime.day, finish.hour, finish.minute);
    duration = _calculateDuration(start: s, finish: f);
  }


  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {columnProject.toString(): project,
      columnTask.toString(): task,
      columnDate.toString() : "${dateTime.day}/${dateTime.month}/${dateTime.year}",
      columnStart.toString() : "${start.hour}:${start.minute}",
      columnFinish.toString() : "${finish.hour}:${finish.minute}",
      columnDuration.toString() : "${duration.inHours}:${duration.inSeconds % 60}",
      columnComment.toString() : comment
    };

    if(id != null){
      map[columnId] = id;
    }

    return map;
  }

  TimeRecord.fromMap(Map map){
    id = map[columnId];
    project = map[columnProject];

    List<dynamic> container = map[columnDate].toString().split("/").map((String element) {
      return int.parse(element);
    }).toList();
    
    dateTime = new DateTime(container[0], container[1], container[2]);

    container.clear();

    container.addAll(map[columnStart].split(":").map((String element) {
      print("fromMap: $element");
      return int.parse(element);
    }).toList());

    start = TimeOfDay(hour: container[0], minute: container[1]);

    container.clear();

    container.addAll(map[columnFinish].toString().split(":").map((String element) {
      return int.parse(element);
    }).toList());
    finish = TimeOfDay(hour: container[0], minute: container[1]);


    duration = _calculateDuration(start: DateTime(dateTime.year, dateTime.month, dateTime.day, start.hour, start.minute), finish: DateTime(dateTime.year, dateTime.month, dateTime.day, finish.hour, finish.minute));
    comment = map[columnComment];

  }

  @override
  String toString() {
    return 'TimeRecord{id: $id, project: $project, task: $task, start: $start, finish: $finish, duration: $duration, dateTime: $dateTime, comment: $comment}';
  }
}

Duration _calculateDuration({DateTime start, DateTime finish}){
  return finish.difference(start);
}

enum Role{
  User,
  Admin
}

enum JobTask{
  Accounting,
  ArmyService,
  Consulting,
  Development,
  General,
  HR,
  Illness,
  Management,
  Marketing,
  Meeting,
  Training,
  Sales,
  PersonalAbsence,
  Subscription,
  Vacation,
  Transport
}

class Project{
  final String name;
  final List<JobTask> tasks;
  const Project({this.name, this.tasks});
}