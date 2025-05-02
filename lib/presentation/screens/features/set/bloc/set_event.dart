import 'package:equatable/equatable.dart';

import '../../../../../data/models/set_model.dart';

abstract class SetEvent extends Equatable {
  const SetEvent();

  @override
  List<Object?> get props => [];
}

class LoadExercise extends SetEvent {
  final String exerciseId;

  const LoadExercise(this.exerciseId);

  @override
  List<Object?> get props => [exerciseId];
}

class LoadSets extends SetEvent {
  final String individualTrainingId;

  const LoadSets(this.individualTrainingId);

  @override
  List<Object?> get props => [individualTrainingId];
}

class AddSet extends SetEvent {
  final SetModel set;

  const AddSet(this.set);

  @override
  List<Object?> get props => [set];
}

class DeleteSet extends SetEvent {
  final String setId;

  const DeleteSet(this.setId);

  @override
  List<Object?> get props => [setId];
}