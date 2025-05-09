import 'package:fittrack/data/services/goal_service.dart';
import 'package:fittrack/presentation/screens/features/meal/bloc/meal_event.dart';
import 'package:fittrack/presentation/screens/features/meal/bloc/meal_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/constants/goal.dart';
import '../../../../../data/services/meal_service.dart';

class MealBloc extends Bloc<MealEvent, MealState>{
  final MealService _mealService;
  final GoalService _goalService;

  MealBloc({required MealService mealService, required GoalService goalService}) :
        _mealService = mealService, _goalService = goalService, super(MealInitial()){
    on<GetUserKcalToday>(_onGetUserKcalToday);
    on<CreateMeal>(_onCreateMeal);
    on<DeleteMealById>(_onDeleteMealById);
  }

  Future<void> _onCreateMeal(
      CreateMeal event,
      Emitter<MealState> emit,
      ) async {
    try{
      emit(MealCreating());

      await _mealService.createMeal(
        date: event.date,
        weight: event.weight,
        name: event.name,
        calories: event.calories,
      );

      emit(MealCreated());
    }
    catch(e){
      emit(MealError(message: e.toString()));
    }
  }

  Future<void> _onGetUserKcalToday(
      GetUserKcalToday event,
      Emitter<MealState> emit,
      )async {
    try{
      emit(MealLoading());

      final meals = await _mealService.getMealByUserIdAdnDate(
        date: event.date,
      );

      final totalCalories = meals.fold<double>(
        0,
            (sum, meal) => sum + meal.calories,
      );

      final goalValue = await _goalService.getGoalValue(goalType: Goal.calories.value);

      emit(MealLoaded(kcalToday: totalCalories, meals: meals, goal: goalValue));
    }
    catch (e) {
      emit(MealError(message: e.toString()));
    }
  }

  Future<void> _onDeleteMealById(
      DeleteMealById event,
      Emitter<MealState> emit,
      ) async {
    try {
      emit(MealLoading());

      await _mealService.deleteMealById(mealId: event.id);

      emit(MealDeleted(mealId: event.id));
    }
    catch(e){
      emit(MealError(message: e.toString()));
    }
  }
}