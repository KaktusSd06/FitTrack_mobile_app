import 'package:equatable/equatable.dart';
import 'package:fittrack/data/models/meal_model.dart';

abstract class MealState extends Equatable {
  const MealState();

  @override
  List<Object?> get props => [];
}

class MealInitial extends MealState {}

class MealLoading extends MealState {}

class MealLoaded extends MealState {
  final double kcalToday;
  final List<MealModel> meals;
  final double goal;

  const MealLoaded({required this.kcalToday, required this.meals, required this.goal});

  @override
  List<Object?> get props => [kcalToday, meals];
}

class MealCreated extends MealState {}

class MealCreating extends MealState {}

class MealError extends MealState {
  final String message;

  const MealError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MealDeleted extends MealState {
  final String mealId;

  const MealDeleted({required this.mealId});

  @override
  List<Object?> get props => [mealId];
}