import 'package:equatable/equatable.dart';

abstract class StepEvent extends Equatable {
  const StepEvent();

  @override
  List<Object> get props => [];
}

class FetchDailySteps extends StepEvent {
  final DateTime date;

  const FetchDailySteps({required this.date});

  @override
  List<Object> get props => [date];
}

class FetchStepsByPeriod extends StepEvent {
  final DateTime fromDate;
  final DateTime toDate;

  const FetchStepsByPeriod({required this.fromDate, required this.toDate});

  @override
  List<Object> get props => [fromDate, toDate];
}

class UpdateSteps extends StepEvent {
  final int steps;
  final DateTime date;
  final bool saveToDb;

  const UpdateSteps({
    required this.steps,
    required this.date,
    this.saveToDb = false,
  });

  @override
  List<Object> get props => [steps, date, saveToDb];
}

class SetStepGoal extends StepEvent {
  final int goalSteps;

  const SetStepGoal({required this.goalSteps});

  @override
  List<Object> get props => [goalSteps];
}

class ForceSync extends StepEvent {
  const ForceSync();
}