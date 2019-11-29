
abstract class BaseState{}

class InitialState extends BaseState{}
class LoadingState extends BaseState{}
class LoadingCompleted<T> extends BaseState{
  final T data;
  LoadingCompleted({this.data});
}
class ErrorState extends BaseState{
  final Exception error;
  ErrorState(this.error);
}


