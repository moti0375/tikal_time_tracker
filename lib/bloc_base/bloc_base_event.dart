
import 'package:flutter/material.dart';

abstract class BlocBaseEvent{}

class DateSelectedEvent extends BlocBaseEvent{
  final DateTime selectedDate;

  DateSelectedEvent({@required this.selectedDate});
}