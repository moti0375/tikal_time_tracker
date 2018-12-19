import 'package:tikal_time_tracker/analytics/endpoint.dart';
import 'package:tikal_time_tracker/analytics/events/event.dart';
class Analytics{
  static const String TAG = "Analytics";
  static Analytics _singleton;

  static List<Endpoint> endpoints = List<Endpoint>();

  static void install(Endpoint ep){
    print("$TAG: install");
    endpoints.add(ep);
  }

  static Analytics init(){
    if (_singleton == null){
      print("$TAG : init");
      _singleton = Analytics._internal();

      endpoints.forEach((ep){
        ep.initialize();
      });
    }
    return _singleton;
  }

  Analytics._internal();

  factory Analytics(){
    print("$TAG: factory");
    return _singleton;
  }

  void logEvent(Event event){
    endpoints.forEach((ep){
      ep.logEvent(event);
    });
  }
}