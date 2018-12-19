import 'package:tikal_time_tracker/analytics/events/base_event.dart';
class ReportsEvent extends BaseEvent{
  ReportsEvent(String name) : super(name){
    bundle = new Map();
    bundle["name"] = name;
  }

  static ReportsEvent click(EVENT_NAME eventName){
    ReportsEvent reportsEvent = ReportsEvent(eventName.toString().split(".").last.toLowerCase());
    reportsEvent.eventType = EVENT_TYPE.CLICK.toString().split(".").last.toLowerCase();
    reportsEvent.bundle["eventType"] = reportsEvent.eventType;
    return reportsEvent;
  }

  static ReportsEvent impression(EVENT_NAME eventName){
    ReportsEvent reportsEvent = ReportsEvent(eventName.toString().split(".").last.toLowerCase());
    reportsEvent.eventType = EVENT_TYPE.IMPRESSION.toString().split(".").last.toLowerCase();
    reportsEvent.bundle["eventType"] = reportsEvent.eventType;
    return reportsEvent;
  }
}

enum EVENT_NAME{
  REPORTS_SCREEN,
  REPORT_PAGE,
  GENERATE_REPORT_CLICKED,
  REPORT_GENERATED_SUCCESS,
  FAILED_TO_GENERATE_REPORT,
  ACTION_SEND_MAIL
}