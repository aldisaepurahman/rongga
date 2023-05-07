import 'package:equatable/equatable.dart';

abstract class RonggaState extends Equatable {
  const RonggaState();

  @override
  List<Object> get props => [];
}

class EmptyState extends RonggaState {}
class LoadingState extends RonggaState {}

class SuccessState extends RonggaState {
  final dynamic datastore;

  const SuccessState(this.datastore);

  @override
  List<Object> get props => [datastore];
}

class CrudState extends RonggaState {
  final bool datastore;

  const CrudState(this.datastore);

  @override
  List<Object> get props => [datastore];
}

class FailureState extends RonggaState {
  final String error;

  const FailureState(this.error);

  @override
  List<Object> get props => [error];
}