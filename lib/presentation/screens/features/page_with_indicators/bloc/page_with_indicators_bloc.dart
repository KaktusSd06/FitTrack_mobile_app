import 'package:fittrack/data/services/weight_service.dart';
import 'package:fittrack/presentation/screens/features/page_with_indicators/bloc/page_with_indicators_event.dart';
import 'package:fittrack/presentation/screens/features/page_with_indicators/bloc/page_with_indicators_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/constants/goal.dart';
import '../../../../../data/services/goal_service.dart';
import '../../../../../data/services/meal_service.dart';
import '../../../../../data/services/sleep_service.dart';
import '../../../../../data/models/sleep/sleep_entry_model.dart';
import '../../../../../data/services/water_service.dart';

class PageWithIndicatorsBloc extends Bloc<PageWithIndicatorsEvent, PageWithIndicatorsState>{
  final MealService _mealService;
  final GoalService _goalService;
  final WeightService _weightService;
  final SleepService _sleepService;
  final WaterService _waterService;

  PageWithIndicatorsBloc({
    required MealService mealService,
    required GoalService goalService,
    required WeightService weightModel,
    required SleepService sleepService,
    required WaterService waterService,
  }) :
        _mealService = mealService,
        _goalService = goalService,
        _weightService = weightModel,
        _sleepService = sleepService,
        _waterService = waterService,
        super(PageWithIndicatorsInitial()){
    //on<GetUserKcalGoal>(_onGetUserKcalGoal);
    on<GetUserKcalSumToday>(_onGetUserKcalSumToday);
  }

  Future<void> _onGetUserKcalSumToday(
      GetUserKcalSumToday event,
      Emitter<PageWithIndicatorsState> emit,
      )async {
    try{
      emit(PageWithIndicatorsLoading());

      // Get meals data
      final meals = await _mealService.getMealByUserIdAdnDate(
        date: event.date,
      );

      final totalCalories = meals.fold<double>(
        0,
            (sum, meal) => sum + meal.calories,
      );

      final goalValue = await _goalService.getGoalValue(goalType: Goal.calories.value);
      final waterGoalValue = await _goalService.getGoalValue(goalType: Goal.water.value);

      final weight = await _weightService.getLatestWeight();

      // Get today's sleep entry
      final todaySleep = await _sleepService.getSleepByUserAndDate(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      );

      // Get today's water intake
      final todayWaterIntake = await _waterService.getWaterIntakeByUserAndDate(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      );

      emit(PageWithIndicatorsLoaded(
        kcalToday: totalCalories,
        goal: goalValue,
        waterGoal: waterGoalValue,
        weight: weight != null ? weight!.weightKg : 0.0,
        sleepEntry: todaySleep ?? SleepEntry(
          id: '',
          sleepStart: DateTime.now(),
          wakeUpTime: DateTime.now(),
          userId: '',
        ),
        waterIntake: todayWaterIntake,
      ));
    }
    catch (e) {
      emit(PageWithIndicatorsError(message: e.toString()));
    }
  }
}