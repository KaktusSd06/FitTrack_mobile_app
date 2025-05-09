import 'package:equatable/equatable.dart';

abstract class SleepStatisticsEvent extends Equatable {
  const SleepStatisticsEvent();

  @override
  List<Object?> get props => [];
}

class FetchSleepStatistics extends SleepStatisticsEvent {
  final DateTime fromDate;
  final DateTime toDate;

  const FetchSleepStatistics({
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [fromDate, toDate];
}