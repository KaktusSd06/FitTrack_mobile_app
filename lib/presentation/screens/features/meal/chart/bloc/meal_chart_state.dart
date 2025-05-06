import 'package:equatable/equatable.dart';

import '../../../../../../data/constants/calories_group_by.dart';
import '../../../../../../data/models/calories_statistics.dart';

abstract class MealChartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MealChartInitial extends MealChartState {}

class MealChartLoading extends MealChartState {}

class MealChartLoaded extends MealChartState {
  final CaloriesStatistics statistics;
  final DateTime fromDate;
  final DateTime toDate;
  final CaloriesGroupBy groupBy;

  MealChartLoaded({
    required this.statistics,
    required this.fromDate,
    required this.toDate,
    required this.groupBy,
  });

  @override
  List<Object?> get props => [statistics, fromDate, toDate, groupBy];

  MealChartLoaded copyWith({
    CaloriesStatistics? statistics,
    DateTime? fromDate,
    DateTime? toDate,
    CaloriesGroupBy? groupBy,
  }) {
    return MealChartLoaded(
      statistics: statistics ?? this.statistics,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      groupBy: groupBy ?? this.groupBy,
    );
  }
}

class MealChartError extends MealChartState {
  final String message;

  MealChartError({required this.message});

  @override
  List<Object> get props => [message];
}