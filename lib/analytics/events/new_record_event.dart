import 'package:tikal_time_tracker/analytics/events/base_event.dart';
class NewRecordEvent extends BaseEvent{
  NewRecordEvent(String name) : super(name){
    bundle["name"] = name;
  }

  static NewRecordEvent click(EVENT_NAME eventName){
    NewRecordEvent newRecordEvent = NewRecordEvent(eventName.toString().split(".").last.toLowerCase());
    newRecordEvent.eventType = EVENT_TYPE.CLICK.toString().split(".").last.toLowerCase();
    newRecordEvent.bundle["eventType"] = newRecordEvent.eventType;
    return newRecordEvent;
  }

  static NewRecordEvent impression(EVENT_NAME eventName){
    NewRecordEvent newRecordEvent = NewRecordEvent(eventName.toString().split(".").last.toLowerCase());
    newRecordEvent.eventType = EVENT_TYPE.IMPRESSION.toString().split(".").last.toLowerCase();
    newRecordEvent.bundle["eventType"] = newRecordEvent.eventType;
    return newRecordEvent;
  }
}

enum EVENT_NAME{
  NEW_TIME_PAGE_OPENED,
  NEW_TIME_PAGE_LOADED,
  CREATING_NEW_RECORD,
  EDITING_RECORD,
  RECORD_SAVED_SUCCESS,
  EDIT_RECORD_SUCCESS,
  FAILED_TO_EDIT_OR_SAVE,
  FAILED_TO_DELETE_RECORD,
  DELETE_RECORD_CLICKED,
  SWIPE_TO_DELETE,
  SAVE_RECORD_CLICKED
}