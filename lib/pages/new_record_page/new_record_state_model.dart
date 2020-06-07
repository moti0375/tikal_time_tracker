import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/remote.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_page.dart';

class NewRecordStateModel {
  bool formOk = false;
  NewRecordFlow flow = NewRecordFlow.new_record;

  TimeRecord timeRecord = new TimeRecord();
  final List<Project> projects = new List<Project>();
  final List<Task> tasks = new List<Task>();

  NewRecordStateModel({List<Project> projects = const <Project>[]}){
   this.projects.clear();
   this.projects.addAll(projects);
  }

  NewRecordStateModel updateWithTimeRecord(TimeRecord timeRecord) {
    this.timeRecord = timeRecord;
    this.formOk = true;
    this.flow = NewRecordFlow.update_record;
    this.tasks.clear();
    this.tasks.addAll(timeRecord.project.tasks);
    return this;
  }

  NewRecordStateModel updateWith(
      {Project project,
        List<Project> projects,
      Task task,
      TimeOfDay startTime,
      TimeOfDay finishTime,
      Duration duration,
      DateTime date,
      String comment,
      bool formOk, Remote remote}) {
    this.timeRecord.task =  task ?? this.timeRecord.task;
    this.timeRecord.start = startTime ?? this.timeRecord.start;
    this.timeRecord.finish = finishTime ?? this.timeRecord.finish;
    this.timeRecord.duration = duration ?? this.timeRecord.duration;
    this.timeRecord.date = date ?? this.timeRecord.date;
    this.timeRecord.comment = comment ?? this.timeRecord.comment;
    this.timeRecord.remote = remote ?? this.timeRecord.remote;
    this.formOk = this.timeRecord.date != null && this.timeRecord.start != null && this.timeRecord.project != null && this.timeRecord.task != null;
    if(project != null){
      this.timeRecord.project = project;
      this.tasks.clear();
      this.tasks.addAll(project.tasks);
      this.timeRecord.task = null;
    }
    if(projects != null){
      this.projects.clear();
      this.projects.addAll(projects);
      this.tasks.clear();
      this.timeRecord.task = null;
    }
    return this;
  }

//  @override
//  List<Object> get props => [selectedProject, selectedTask, startTime.toString(), finishTime.toString(), duration.toString(), selectedDate.toIso8601String(), comment, formOk];

}
