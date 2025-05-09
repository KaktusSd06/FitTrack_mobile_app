import 'package:equatable/equatable.dart';
import '../../../../../data/models/sleep_statistic_response.dart';

abstract class SleepStatisticsState extends Equatable {
  const SleepStatisticsState();

  @override
  List<Object?> get props => [];
}

class SleepStatisticsInitial extends SleepStatisticsState {}

class SleepStatisticsLoading extends SleepStatisticsState {}

class SleepStatisticsLoaded extends SleepStatisticsState {
  final SleepStatisticResponse statistics;
  final DateTime fromDate;
  final DateTime toDate;

  const SleepStatisticsLoaded({
    required this.statistics,
    required this.fromDate,
    required this.toDate,
  });

  // Calculate average sleep hours (for display)
  String get averageSleepHours {
    final hours = statistics.averageDurationMinutes ~/ 60;
    final minutes = statistics.averageDurationMinutes % 60;
    return '$hours год $minutes хв';
  }

  // Calculate goal completion rate
  double get goalCompletionRate {
    if (statistics.sleepGrouped.isEmpty) return 0.0;

    final completedDays = statistics.sleepGrouped
        .where((entry) => entry.durationMinutes >= 8 * 60) // 8 hours in minutes
        .length;

    return completedDays / statistics.sleepGrouped.length;
  }

  @override
  List<Object?> get props => [statistics, fromDate, toDate];
}

class SleepStatisticsError extends SleepStatisticsState {
  final String message;

  const SleepStatisticsError({required this.message});

  @override
  List<Object?> get props => [message];
}