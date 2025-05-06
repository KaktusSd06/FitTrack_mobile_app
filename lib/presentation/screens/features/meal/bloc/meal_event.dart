import 'package:equatable/equatable.dart';

abstract class MealEvent extends Equatable {
  const MealEvent();

  @override
  List<Object?> get props => [];
}

class GetUserKcalToday extends MealEvent {
  final DateTime date;

  const GetUserKcalToday({
    required this.date,
  });

  @override
  List<Object?> get props => [date];
}

class GetUserKcalGoal extends MealEvent {
  @override
  List<Object?> get props => [];
}

class CreateMeal extends MealEvent{
  final String name;
  final DateTime date;
  final int weight;
  final double calories;

  const CreateMeal({
    required this.name,
    required this.date,
    required this.weight,
    required this.calories,
});
}

class DeleteMealById extends MealEvent{
  final String id;

  const DeleteMealById({
    required this.id,
});
}