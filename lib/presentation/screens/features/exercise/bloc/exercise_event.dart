import 'package:equatable/equatable.dart';

import '../../../../../data/models/exercise_model.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object> get props => [];
}

class LoadExercises extends ExerciseEvent {}

class AddExercise extends ExerciseEvent {
  final ExerciseModel exercise;

  const AddExercise(this.exercise);

  @override
  List<Object> get props => [exercise];
}


abstract class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object> get props => [];
}