import 'package:flutter/material.dart';
import '../../data/project.dart';
import '../../data/models.dart';
import '../../data/task.dart';

class NewRecordPresenterContract{
  void subscribe(NewRecordViewContract view){}
  void projectSelected(Project project){}
  void taskSelected(Task task){}
  void dateSelected(DateTime startDate){}
  void startTimeSelected(TimeOfDay startTime){}
  void endTimeSelected(TimeOfDay endTime){}
  void commentEntered(String comment){}
  void saveButtonClicked(){}
  void noteChanged(String note){}
}

class NewRecordViewContract{
  void initNewRecord(){}
  void initUpdateRecord(){}
  void showSelectedProject(Project project){}
  void showSelectedTask(Task task){}
  void showAssignedTasks(List<Task> tasks){}
  void showSelectedDate(DateTime date){}
  void showSelectedStartTime(TimeOfDay startTime){}
  void showSelectedFinishTime(TimeOfDay finishTime){}
  void showDuration(Duration duration){}
  void showSaveRecordSuccess(TimeRecord timeRecord){}
  void showSaveRecordFailed(){}
  void setButtonState(bool enabled){}
}