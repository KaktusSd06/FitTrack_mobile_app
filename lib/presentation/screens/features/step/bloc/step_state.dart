import 'package:equatable/equatable.dart';

import '../../../../../data/models/step_info_model.dart';

abstract class StepState extends Equatable {
  const StepState();

  @override
  List<Object?> get props => [];
}

class StepInitial extends StepState {}

class StepLoading extends StepState {}

class StepLoaded extends StepState {
  final List<StepsInfo> steps;
  final int dailySteps;
  final double distance;
  final int calories;
  final int goalSteps;
  final int totalStepsInPeriod;
  final double averageDistance;
  final bool isGoalAchieved;

  const StepLoaded({
    required this.steps,
    required this.dailySteps,
    required this.distance,
    required this.calories,
    required this.goalSteps,
    required this.totalStepsInPeriod,
    required this.averageDistance,
    required this.isGoalAchieved,
  });

  @override
  List<Object?> get props => [
    steps,
    dailySteps,
    distance,
    calories,
    goalSteps,
    totalStepsInPeriod,
    averageDistance,
    isGoalAchieved,
  ];

  StepLoaded copyWith({
    List<StepsInfo>? steps,
    int? dailySteps,
    double? distance,
    int? calories,
    int? goalSteps,
    int? totalStepsInPeriod,
    double? averageDistance,
    bool? isGoalAchieved,
  }) {
    return StepLoaded(
      steps: steps ?? this.steps,
      dailySteps: dailySteps ?? this.dailySteps,
      distance: distance ?? this.distance,
      calories: calories ?? this.calories,
      goalSteps: goalSteps ?? this.goalSteps,
      totalStepsInPeriod: totalStepsInPeriod ?? this.totalStepsInPeriod,
      averageDistance: averageDistance ?? this.averageDistance,
      isGoalAchieved: isGoalAchieved ?? this.isGoalAchieved,
    );
  }
}

class StepError extends StepState {
  final String message;

  const StepError({required this.message});

  @override
  List<Object> get props => [message];
}