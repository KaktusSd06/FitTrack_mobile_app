import 'package:equatable/equatable.dart';

abstract class GoalEvent extends Equatable {
  const GoalEvent();

  @override
  List<Object?> get props => [];
}

class CreateGoalByType extends GoalEvent{
  final String goalType;
  final int value;

  const CreateGoalByType({required this.goalType, required this.value});

  @override
  List<Object?> get props => [goalType];
}
