import 'package:tikal_time_tracker/analytics/events/event.dart';
class BaseEvent extends Event{
  String eventType;
  String action;
  String details;

  BaseEvent(String name){
    super.name = name;
  }

   BaseEvent open(){
    action = ACTION.OPEN.toString().split(".").last.toLowerCase();
    bundle["action"] = action;
    return this;
  }

  BaseEvent view(){
    action = ACTION.OPEN.toString().split(".").last.toLowerCase();
    bundle["action"] = action;
    return this;
  }

  BaseEvent setDetails(String details){
    this.details = details;
    bundle["details"] = details;
    return this;
  }
}

enum EVENT_TYPE{
  IMPRESSION,
  CLICK
}

enum ACTION{
  VIEW,
  OPEN
}