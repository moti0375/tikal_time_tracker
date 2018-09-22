import 'package:flutter/material.dart';

class Utils {
  static String buildTimeStringFromTime(TimeOfDay time) {
    return "${time.hour}:${time.minute % 60 < 10 ? "0${time.minute % 60}" : time.minute % 60}";
  }

  static String buildTimeStringFromDuration(Duration duration) {
    return "${duration.inHours}:${duration.inMinutes % 60 < 10 ? "0${duration.inMinutes % 60}" : duration.inMinutes % 60}";
  }
}
