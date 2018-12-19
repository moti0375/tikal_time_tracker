import 'package:tikal_time_tracker/analytics/events/base_event.dart';
class UsersEvent extends BaseEvent{
  UsersEvent(String name) : super(name){
    bundle["name"] = name;
  }

  static UsersEvent click(EVENT_NAME eventName){
    UsersEvent event = UsersEvent(eventName.toString().split(".").last.toLowerCase());
    event.eventType = EVENT_TYPE.CLICK.toString().split(".").last.toLowerCase();
    event.bundle["eventType"] = event.eventType;
    return event;
  }

  static UsersEvent impression(EVENT_NAME eventName){
    UsersEvent event = UsersEvent(eventName.toString().split(".").last.toLowerCase());
    event.eventType = EVENT_TYPE.IMPRESSION.toString().split(".").last.toLowerCase();
    event.bundle["eventType"] = event.eventType;
    return event;
  }
}

enum EVENT_NAME{
  USERS_SCREEN,
  LOAD_USERS_SUCCESS,
}