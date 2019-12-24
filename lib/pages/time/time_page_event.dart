import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tikal_time_tracker/data/models.dart';

abstract class TimePageEvent{}
class ContextRequiredEvent extends TimePageEvent{
  final BuildContext context;
  ContextRequiredEvent({@required this.context});
}

class DateSelectedEvent extends TimePageEvent{
  final DateTime selectedDate;
  DateSelectedEvent({@required this.selectedDate});
}

class DatePickerSelectedEvent extends TimePageEvent{
  final DateTime selectedDate;
  DatePickerSelectedEvent({@required this.selectedDate});
}

class OnAboutItemClicked extends TimePageEvent{
  final BuildContext context;
  OnAboutItemClicked({@required this.context});
}

class LogoutItemClicked extends TimePageEvent{}
class FabAddRecordClicked extends ContextRequiredEvent{
  FabAddRecordClicked(BuildContext context) : super(context: context);
}

class EmptyScreenAddRecordClicked extends ContextRequiredEvent{
  EmptyScreenAddRecordClicked(BuildContext context) : super(context: context);
}

class OnTimeRecordItemClicked extends ContextRequiredEvent{
  final TimeRecord timeRecord;
  OnTimeRecordItemClicked(BuildContext context, {@required this.timeRecord}) : super(context: context);
}

class OnItemDismissed extends ContextRequiredEvent{
  final TimeRecord timeRecord;
  OnItemDismissed(BuildContext context, {this.timeRecord}) : super(context: context);
}