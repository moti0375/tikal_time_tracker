import 'package:tikal_time_tracker/analytics/events/base_event.dart';
class NewRecordeEvent extends BaseEvent{
  NewRecordeEvent(String name) : super(name){
    bundle["name"] = name;
  }

  static NewRecordeEvent click(EVENT_NAME eventName){
    NewRecordeEvent newRecordEvent = NewRecordeEvent(eventName.toString().split(".").last.toLowerCase());
    newRecordEvent.eventType = EVENT_TYPE.CLICK.toString().split(".").last.toLowerCase();
    newRecordEvent.bundle["eventType"] = newRecordEvent.eventType;
    return newRecordEvent;
  }

  static NewRecordeEvent impression(EVENT_NAME eventName){
    NewRecordeEvent newRecordEvent = NewRecordeEvent(eventName.toString().split(".").last.toLowerCase());
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
  DELETE_RECORD_CLICKED,
  SAVE_RECORD_CLICKED
}