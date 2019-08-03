import 'package:tikal_time_tracker/analytics/events/base_event.dart';
class TimeEvent extends BaseEvent{
  TimeEvent(String name) : super(name){
    bundle["name"] = name;
  }

  static TimeEvent click(EVENT_NAME eventName){
    TimeEvent timeEvent = TimeEvent(eventName.toString().split(".").last.toLowerCase());
    timeEvent.eventType = EVENT_TYPE.CLICK.toString().split(".").last.toLowerCase();
    timeEvent.bundle["eventType"] = timeEvent.eventType;
    return timeEvent;
  }

  static TimeEvent impression(EVENT_NAME eventName){
    TimeEvent loginEvent = TimeEvent(eventName.toString().split(".").last.toLowerCase());
    loginEvent.eventType = EVENT_TYPE.IMPRESSION.toString().split(".").last.toLowerCase();
    loginEvent.bundle["eventType"] = loginEvent.eventType;
    return loginEvent;
  }
}

enum EVENT_NAME{
  TIME_PAGE_OPENED,
  TIME_PAGE_LOADED,
  FAILED_TO_LOAD_PAGE,
  NEW_RECORD_FAB_CLICKED,
  NEW_RECORD_SCREEN_CLICKED,
  NEW_RECORD_LOADED,
  DATE_PICKER_USED,
  TIME_PICKER_NOW,
  TIME_PICKER_ICON,
  ACTION_LOGOUT,
  ACTION_ABOUT
}