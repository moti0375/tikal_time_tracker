import 'package:equatable/equatable.dart';

abstract class NameValueEntity extends Equatable{
  final String name;
  final int value;

  NameValueEntity({this.name, this.value});

}