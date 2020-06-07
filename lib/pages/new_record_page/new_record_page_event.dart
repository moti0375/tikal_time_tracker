import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/remote.dart';
import 'package:tikal_time_tracker/data/task.dart';

abstract class NewRecordPageEvent{}

@immutable
class OnSelectedRemote extends NewRecordPageEvent{
  final Remote selectedRemote;
  OnSelectedRemote({@required this.selectedRemote});
}


@immutable
class OnSelectedProject extends NewRecordPageEvent{
  final Project selectedProject;
  OnSelectedProject({@required this.selectedProject});
}

@immutable
class OnSelectedTask extends NewRecordPageEvent{
  final Task selectedTask;
  OnSelectedTask({@required this.selectedTask});
}

@immutable
class OnStartTime extends NewRecordPageEvent{
  final TimeOfDay selectedTime;
  OnStartTime({@required this.selectedTime});
}

@immutable
class OnFinishTime extends NewRecordPageEvent{
  final TimeOfDay selectedTime;
  OnFinishTime({@required this.selectedTime});
}

@immutable
class OnDateSelected extends NewRecordPageEvent{
  final DateTime selectedDate;
  OnDateSelected({@required this.selectedDate});
}

@immutable
class OnSaveButtonClicked extends NewRecordPageEvent{
  final BuildContext context;
  OnSaveButtonClicked({@required this.context});
}
@immutable
class OnDeleteButtonClicked extends NewRecordPageEvent{
  final BuildContext context;
  OnDeleteButtonClicked({@required this.context});
}

@immutable
class OnComment extends NewRecordPageEvent{
  final String comment;
  OnComment({@required this.comment});
}

@immutable
class OnNowButtonClicked extends NewRecordPageEvent{}

