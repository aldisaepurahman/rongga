import 'package:equatable/equatable.dart';

abstract class Events extends Equatable {
  @override
  List<Object> get props => [];
}

class ResetEvent extends Events {
  ResetEvent();
}