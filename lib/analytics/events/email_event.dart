import 'package:tikal_time_tracker/analytics/events/base_event.dart';
class EmailEvent extends BaseEvent{
  EmailEvent(String name) : super(name){
    bundle = new Map();
    bundle["name"] = name;
  }

  static EmailEvent click(EVENT_NAME eventName){
    EmailEvent event = EmailEvent(eventName.toString().split(".").last.toLowerCase());
    event.eventType = EVENT_TYPE.CLICK.toString().split(".").last.toLowerCase();
    event.bundle["eventType"] = event.eventType;
    return event;
  }

  static EmailEvent impression(EVENT_NAME eventName){
    EmailEvent event = EmailEvent(eventName.toString().split(".").last.toLowerCase());
    event.eventType = EVENT_TYPE.IMPRESSION.toString().split(".").last.toLowerCase();
    event.bundle["eventType"] = event.eventType;
    return event;
  }
}

enum EVENT_NAME{
  EMAIL_SCREEN,
  MAIL_FORM_LOADED,
  SEND_MAIL_CLICKED,
  MAIL_SENT
}