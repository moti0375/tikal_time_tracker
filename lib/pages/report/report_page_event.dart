import 'package:flutter/cupertino.dart';

abstract class ReportPageEvent{}
class ContextRequiredEvent extends ReportPageEvent{
  final BuildContext context;
  ContextRequiredEvent({@required this.context});
}
class OnAnalysisItemClick extends ContextRequiredEvent {
  OnAnalysisItemClick(BuildContext context) : super(context: context);
}