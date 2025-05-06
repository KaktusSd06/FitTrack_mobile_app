import 'package:fittrack/data/services/weight_service.dart';
import 'package:fittrack/presentation/screens/features/page_with_indicators/bloc/page_with_indicators_event.dart';
import 'package:fittrack/presentation/screens/features/page_with_indicators/bloc/page_with_indicators_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/constants/goal.dart';
import '../../../../../data/services/goal_service.dart';
import '../../../../../data/services/meal_service.dart';

class PageWithIndicatorsBloc extends Bloc<PageWithIndicatorsEvent, PageWithIndicatorsState>{
  final MealService _mealService;
  final GoalService _goalService;
  final WeightService _weightService;

  PageWithIndicatorsBloc({required MealService mealService, required GoalService goalService, required WeightService weightModel}) :
        _mealService = mealService, _goalService = goalService, _weightService = weightModel, super(PageWithIndicatorsInitial()){
    //on<GetUserKcalGoal>(_onGetUserKcalGoal);
    on<GetUserKcalSumToday>(_onGetUserKcalSumToday);
  }

  Future<void> _onGetUserKcalSumToday(
      GetUserKcalSumToday event,
      Emitter<PageWithIndicatorsState> emit,
      )async {
    try{
      emit(PageWithIndicatorsLoading());

      final meals = await _mealService.getMealByUserIdAdnDate(
        date: event.date,
      );

      final totalCalories = meals.fold<double>(
        0,
            (sum, meal) => sum + meal.calories,
      );

      final goalValue = await _goalService.getGoalValue(goalType: Goal.calories.value);

      final weight = await _weightService.getLatestWeight();

      emit(PageWithIndicatorsLoaded(kcalToday: totalCalories, goal: goalValue, weight: weight!.weightKg));
    }
    catch (e) {
      emit(PageWithIndicatorsError(message: e.toString()));
    }
  }
}