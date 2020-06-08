import 'package:equatable/equatable.dart';

class Remote extends Equatable {
  final String name;
  final int value;

  Remote({this.name, this.value});

  @override
  List<Object> get props => [name, value];

  @override
  bool get stringify => true;
}