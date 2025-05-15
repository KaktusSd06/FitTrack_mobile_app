import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/services/sleep_statistics_service.dart';
import 'sleep_statistics_event.dart';
import 'sleep_statistics_state.dart';

class SleepStatisticsBloc extends Bloc<SleepStatisticsEvent, SleepStatisticsState> {
  final SleepStatisticsService _sleepStatisticsService;

  SleepStatisticsBloc({
    required SleepStatisticsService sleepStatisticsService,
  })  : _sleepStatisticsService = sleepStatisticsService,
        super(SleepStatisticsInitial()) {
    on<FetchSleepStatistics>(_onFetchSleepStatistics);
  }

  Future<void> _onFetchSleepStatistics(
      FetchSleepStatistics event,
      Emitter<SleepStatisticsState> emit,
      ) async {
    emit(SleepStatisticsLoading());

    try {
      final sleepStatistics = await _sleepStatisticsService.fetchSleepStatistics(
        fromDate: event.fromDate,
        toDate: event.toDate,
      );

      // Create a copy of the response with sorted entries
      final sortedStatistics = sleepStatistics;

      emit(SleepStatisticsLoaded(
        statistics: sortedStatistics,
        fromDate: event.fromDate,
        toDate: event.toDate,
      ));
    } catch (e) {
      emit(SleepStatisticsError(message: e.toString()));
    }
  }
}