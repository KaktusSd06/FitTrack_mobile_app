import 'package:equatable/equatable.dart';
import 'package:fittrack/data/models/group_training.dart';

abstract class GroupTrainingState extends Equatable {
  const GroupTrainingState();

  @override
  List<Object?> get props => [];
}

class GroupTrainingInitial extends GroupTrainingState {}

class GroupTrainingLoading extends GroupTrainingState {}

class GroupTrainingLoaded extends GroupTrainingState {
  final List<GroupTraining> groupTrainings;

  const GroupTrainingLoaded({
    required this.groupTrainings,
  });

  @override
  List<Object?> get props => [groupTrainings];
}

class GroupTrainingError extends GroupTrainingState {
  final String message;

  const GroupTrainingError({required this.message});

  @override
  List<Object?> get props => [message];
}