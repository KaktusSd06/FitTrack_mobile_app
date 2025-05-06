import 'package:equatable/equatable.dart';

import '../../../../../../data/constants/calories_group_by.dart';

abstract class MealChartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMealChartData extends MealChartEvent {
  final DateTime fromDate;
  final DateTime toDate;
  final CaloriesGroupBy groupBy;

  LoadMealChartData({
    required this.fromDate,
    required this.toDate,
    required this.groupBy,
  });

  @override
  List<Object> get props => [fromDate, toDate, groupBy];
}

class ChangeDateRange extends MealChartEvent {
  final DateTime fromDate;
  final DateTime toDate;

  ChangeDateRange({
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object> get props => [fromDate, toDate];
}

class ChangeGroupBy extends MealChartEvent {
  final CaloriesGroupBy groupBy;

  ChangeGroupBy({required this.groupBy});

  @override
  List<Object> get props => [groupBy];
}