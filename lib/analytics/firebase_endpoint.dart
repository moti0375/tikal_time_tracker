import 'package:tikal_time_tracker/analytics/endpoint.dart';
import 'package:tikal_time_tracker/analytics/events/event.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseEndpoint implements Endpoint{
  final String TAG = "FirebaseEndpoint";
  FirebaseAnalytics firebaseAnalytics;
  @override
  void initialize() {
    firebaseAnalytics = new FirebaseAnalytics();
  }

  @override
  void logEvent(Event event) async {
    print("$TAG: logEvent: ${event.toString()}");
    if(firebaseAnalytics == null){
      initialize();
    }
    firebaseAnalytics.logEvent(name: event.name, parameters: event.bundle).then((_){
      print("$TAG: logEvent: success ");
    }, onError: (e){
      print("$TAG: There was an error $e");
    });
  }
}