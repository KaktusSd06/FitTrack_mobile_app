import 'package:equatable/equatable.dart';
import 'package:fittrack/data/models/gym_model.dart';

import '../../../../../../data/models/trainer_model.dart';

abstract class TrainersState extends Equatable {
  const TrainersState();

  @override
  List<Object?> get props => [];
}

class TrainersInitial extends TrainersState {}

class TrainersLoading extends TrainersState {}

class TrainersLoaded extends TrainersState {
  final List<TrainerModel> trainers;

  const TrainersLoaded({
    required this.trainers,
  });

  @override
  List<Object?> get props => [trainers];
}

class TrainersError extends TrainersState {
  final String message;

  const TrainersError({required this.message});

  @override
  List<Object?> get props => [message];
}