import 'package:flutter/material.dart';
import '../data/database/database_helper.dart';
import '../data/project.dart';
import '../data/task.dart';

class TimeRecord{
  int id;
  Project project;
  Task task;
  TimeOfDay start;
  TimeOfDay finish;
  Duration duration;
  DateTime date;
  String comment;

  TimeRecord.empty(){

  }

  TimeRecord({this.id, this.project, this.task, this.start, this.finish,
      this.date, this.comment, this.duration}){
    DateTime s  = DateTime(date.year, date.month, date.day, start.hour, start.minute);
    if(this.finish != null){
      DateTime f  = DateTime(date.year, date.month, date.day, finish.hour, finish.minute);
      duration = _calculateDuration(start: s, finish: f);
    }
    print("TimeRecord: ${date.millisecondsSinceEpoch}");
  }


  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {columnProject.toString(): project,
      columnTask.toString(): task,
      columnDate.toString() : date.millisecondsSinceEpoch,
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
    task = map[columnTask];

    date = DateTime.fromMillisecondsSinceEpoch(map[columnDate]);

    List<dynamic> container = map[columnStart].toString().split(":").map((String element) {
      return int.parse(element);
    }).toList();

    start = TimeOfDay(hour: container[0], minute: container[1]);

    container.clear();

    container.addAll(map[columnFinish].toString().split(":").map((String element) {
      return int.parse(element);
    }).toList());
    finish = TimeOfDay(hour: container[0], minute: container[1]);


    duration = _calculateDuration(start: DateTime(date.year, date.month, date.day, start.hour, start.minute), finish: DateTime(date.year, date.month, date.day, finish.hour, finish.minute));
    comment = map[columnComment];

  }

  @override
  String toString() {
    return 'TimeRecord{id: $id, project: $project, task: $task, start: $start, finish: $finish, duration: $duration, dateTime: ${date.millisecondsSinceEpoch}, comment: $comment}';
  }

  String getDurationString(){
    return "${duration.inHours}:${duration.inMinutes % 60 == 0 ? "00" : duration.inMinutes % 60 < 10 ? "0${duration.inMinutes % 60}" : duration.inMinutes % 60}";
  }
}

Duration _calculateDuration({DateTime start, DateTime finish}){
  return finish.difference(start);
}

enum Role{
  User,
  Manager,
  CoManager,
  TopManager
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



class Report{
  final DateTime startDate;
  final DateTime endDate;
  final List<TimeRecord> report;
  final Project project;
  final String task;
  int total = 0;

  Report({this.startDate, this.endDate, this.report, this.project, this.task}){
    _calculateTotal();
  }

  _calculateTotal(){
    if(this.report.isNotEmpty){
      print("Calcultate total.. ${this.report.toString()}");
      this.report.forEach((r){
        print("Calcultate total.. ${r.duration.inMinutes}");
        total = total +  r.duration.inMinutes;
      });
    }else{
      print("report is empty");
      total = 0;
    }
    print("Total: $total");
  }

  String getTotalString(){
    return "${total~/60}:${total % 60 == 0 ? "00" : total % 60 < 10 ? "0${total % 60}" : total % 60}";
  }

  @override
  String toString() {
    return 'Report{startDate: $startDate, endTime: $endDate, report: $report, project: $project, task: $task}';
  }

}

