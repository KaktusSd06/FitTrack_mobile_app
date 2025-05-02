import 'package:equatable/equatable.dart';
import '../../../../../data/models/individual_training_model.dart';

abstract class IndividualTrainingState extends Equatable {
  const IndividualTrainingState();

  @override
  List<Object?> get props => [];
}

class IndividualTrainingInitial extends IndividualTrainingState {}

class IndividualTrainingLoading extends IndividualTrainingState {}

class IndividualTrainingLoaded extends IndividualTrainingState {
  final IndividualTrainingModel trainings;

  const IndividualTrainingLoaded({required this.trainings});

  @override
  List<Object?> get props => [trainings];
}

class IndividualTrainingCreated extends IndividualTrainingState {}

class IndividualTrainingError extends IndividualTrainingState {
  final String message;

  const IndividualTrainingError({required this.message});

  @override
  List<Object?> get props => [message];
}