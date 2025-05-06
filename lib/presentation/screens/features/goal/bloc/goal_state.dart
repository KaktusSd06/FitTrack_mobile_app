import 'package:equatable/equatable.dart';

abstract class GoalState extends Equatable{
  const GoalState();

  @override
  List<Object?> get props => [];
}

class GoalInitial extends GoalState {}

class GoalAdding extends GoalState {}

class GoalAdded extends GoalState {
  final String goalType;
  final int value;

  const GoalAdded({required this.goalType, required this.value});

  @override
  List<Object?> get props => [goalType];
}

class GoalError extends GoalState {
  final String message;

  const GoalError({required this.message});

  @override
  List<Object?> get props => [message];
}