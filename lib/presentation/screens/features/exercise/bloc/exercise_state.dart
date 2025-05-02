import '../../../../../data/models/exercise_model.dart';
import 'exercise_event.dart';

class ExercisesInitial extends ExerciseState {}

class ExercisesLoading extends ExerciseState {}

class ExercisesLoaded extends ExerciseState {
  final List<ExerciseModel> exercises;

  const ExercisesLoaded(this.exercises);

  @override
  List<Object> get props => [exercises];
}

class ExerciseAdded extends ExerciseState {
  final ExerciseModel exercise;

  const ExerciseAdded(this.exercise);

  @override
  List<Object> get props => [exercise];
}

class ExerciseError extends ExerciseState {
  final String message;

  const ExerciseError(this.message);

  @override
  List<Object> get props => [message];
}