import 'package:equatable/equatable.dart';
import 'package:fittrack/data/models/sleep_entry_model.dart';
import 'package:fittrack/data/models/water_intake_model.dart';

abstract class PageWithIndicatorsState extends Equatable {
  const PageWithIndicatorsState();

  @override
  List<Object?> get props => [];
}

class PageWithIndicatorsInitial extends PageWithIndicatorsState {}

class PageWithIndicatorsLoading extends PageWithIndicatorsState {}

class PageWithIndicatorsLoaded extends PageWithIndicatorsState {
  final double kcalToday;
  final double goal;
  final double waterGoal;
  final double weight;
  final SleepEntry sleepEntry;
  final WaterIntake? waterIntake;

  const PageWithIndicatorsLoaded({
    required this.kcalToday,
    required this.goal,
    required this.waterGoal,
    required this.weight,
    required this.sleepEntry,
    this.waterIntake,
  });

  @override
  List<Object?> get props => [kcalToday, goal, waterGoal, weight, sleepEntry, waterIntake];
}

class PageWithIndicatorsCreated extends PageWithIndicatorsState {}

class PageWithIndicatorsError extends PageWithIndicatorsState {
  final String message;

  const PageWithIndicatorsError({required this.message});

  @override
  List<Object?> get props => [message];
}