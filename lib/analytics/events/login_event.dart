import 'package:tikal_time_tracker/analytics/events/base_event.dart';
class LoginEvent extends BaseEvent{
  LoginEvent(String name) : super(name){
    bundle["name"] = name;
  }

  static LoginEvent click(EVENT_NAME eventName){
    LoginEvent loginEvent = LoginEvent(eventName.toString().split(".").last.toLowerCase());
    loginEvent.eventType = EVENT_TYPE.CLICK.toString().split(".").last.toLowerCase();
    loginEvent.bundle["eventType"] = loginEvent.eventType;
    return loginEvent;
  }

  static LoginEvent impression(EVENT_NAME eventName){
    LoginEvent loginEvent = LoginEvent(eventName.toString().split(".").last.toLowerCase());
    loginEvent.eventType = EVENT_TYPE.IMPRESSION.toString().split(".").last.toLowerCase();
    loginEvent.bundle["eventType"] = loginEvent.eventType;
    return loginEvent;
  }
}

enum EVENT_NAME{
  SIGN_IN_CLICKED,
  SING_IN_OK,
  SING_IN_FAILED,
  LOGIN_PAGE_OPENED,
  LOGIN_CLICKED,
  LOGIN_OK,
  LOGIN_FAILED
}