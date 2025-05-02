

import 'package:equatable/equatable.dart';

import '../../../../../data/models/exercise_model.dart';
import '../../../../../data/models/set_model.dart';

abstract class SetState extends Equatable {
  const SetState();

  @override
  List<Object?> get props => [];
}

class SetInitial extends SetState {}

class SetLoading extends SetState {}

class ExerciseLoaded extends SetState {
  final ExerciseModel exercise;

  const ExerciseLoaded(this.exercise);

  @override
  List<Object?> get props => [exercise];
}

class SetsLoaded extends SetState {
  final List<SetModel> sets;

  const SetsLoaded(this.sets);

  @override
  List<Object?> get props => [sets];
}

class SetAdded extends SetState {
  final SetModel set;

  const SetAdded(this.set);

  @override
  List<Object?> get props => [set];
}

class SetDeleted extends SetState {
  final String setId;

  const SetDeleted(this.setId);

  @override
  List<Object?> get props => [setId];
}

class SetFailure extends SetState {
  final String errorMessage;

  const SetFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}