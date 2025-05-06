import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../data/services/calories_statistics_service.dart';
import 'meal_chart_event.dart';
import 'meal_chart_state.dart';

class MealChartBloc extends Bloc<MealChartEvent, MealChartState> {
  final CaloriesStatisticsService _statisticsService;

  MealChartBloc({required CaloriesStatisticsService statisticsService})
      : _statisticsService = statisticsService,
        super(MealChartInitial()) {
    on<LoadMealChartData>(_onLoadMealChartData);
    on<ChangeDateRange>(_onChangeDateRange);
    on<ChangeGroupBy>(_onChangeGroupBy);
  }

  Future<void> _onLoadMealChartData(
      LoadMealChartData event,
      Emitter<MealChartState> emit,
      ) async {
    try {
      emit(MealChartLoading());

      final statistics = await _statisticsService.fetchCaloriesStatistics(
        fromDate: event.fromDate,
        toDate: event.toDate,
        groupBy: event.groupBy,
      );

      emit(MealChartLoaded(
        statistics: statistics,
        fromDate: event.fromDate,
        toDate: event.toDate,
        groupBy: event.groupBy,
      ));
    } catch (e) {
      emit(MealChartError(message: e.toString()));
    }
  }

  Future<void> _onChangeDateRange(
      ChangeDateRange event,
      Emitter<MealChartState> emit,
      ) async {
    if (state is MealChartLoaded) {
      final currentState = state as MealChartLoaded;

      try {
        emit(MealChartLoading());

        final statistics = await _statisticsService.fetchCaloriesStatistics(
          fromDate: event.fromDate,
          toDate: event.toDate,
          groupBy: currentState.groupBy,
        );

        emit(MealChartLoaded(
          statistics: statistics,
          fromDate: event.fromDate,
          toDate: event.toDate,
          groupBy: currentState.groupBy,
        ));
      } catch (e) {
        emit(MealChartError(message: e.toString()));
      }
    }
  }

  Future<void> _onChangeGroupBy(
      ChangeGroupBy event,
      Emitter<MealChartState> emit,
      ) async {
    if (state is MealChartLoaded) {
      final currentState = state as MealChartLoaded;

      try {
        emit(MealChartLoading());

        final statistics = await _statisticsService.fetchCaloriesStatistics(
          fromDate: currentState.fromDate,
          toDate: currentState.toDate,
          groupBy: event.groupBy,
        );

        emit(MealChartLoaded(
          statistics: statistics,
          fromDate: currentState.fromDate,
          toDate: currentState.toDate,
          groupBy: event.groupBy,
        ));
      } catch (e) {
        emit(MealChartError(message: e.toString()));
      }
    }
  }
}