import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/task.dart';

class NewRecordPresenterContract{
  void subscribe(NewRecordViewContract view){}
  void projectSelected(Project project){}
  void taskSelected(Task task){}
  void dateSelected(DateTime startDate){}
  void startTimeSelected(TimeOfDay startTime){}
  void endTimeSelected(TimeOfDay endTime){}
  void commentEntered(String comment){}
  void saveButtonClicked(){}
  void deleteButtonClicked(){}
  void noteChanged(String note){}
}

abstract class NewRecordViewContract{
  void initNewRecord(){}
  void initUpdateRecord(){}
  void showSelectedProject(Project project){}
  void showSelectedTask(Task task){}
  void showAssignedTasks(List<Task> tasks){}
  void showDuration(Duration duration){}
  void showSaveRecordSuccess(TimeRecord timeRecord){}
  void showSaveRecordFailed(){}
  void setButtonState(bool enabled){}
  void onError(Exception e);
}