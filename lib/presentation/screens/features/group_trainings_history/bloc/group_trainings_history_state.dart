import 'package:equatable/equatable.dart';
import 'package:fittrack/data/models/group_training.dart';

abstract class GroupTrainingHistoryState extends Equatable {
  const GroupTrainingHistoryState();

  @override
  List<Object?> get props => [];
}

class GroupTrainingHistoryInitial extends GroupTrainingHistoryState {}

class GroupTrainingHistoryLoading extends GroupTrainingHistoryState {}

class GroupTrainingHistoryLoaded extends GroupTrainingHistoryState {
  final List<GroupTraining> groupTrainings;

  const GroupTrainingHistoryLoaded({
    required this.groupTrainings,
  });

  @override
  List<Object?> get props => [groupTrainings];
}

class GroupTrainingHistoryError extends GroupTrainingHistoryState {
  final String message;

  const GroupTrainingHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}