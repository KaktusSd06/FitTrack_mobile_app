import 'package:equatable/equatable.dart';

abstract class PageWithIndicatorsEvent extends Equatable {
  const PageWithIndicatorsEvent();

  @override
  List<Object?> get props => [];
}

class GetUserKcalSumToday extends PageWithIndicatorsEvent {
  final DateTime date;

  const GetUserKcalSumToday({
    required this.date,
  });

  @override
  List<Object?> get props => [date];
}

class GetUserKcalGoal extends PageWithIndicatorsEvent {
  @override
  List<Object?> get props => [];
}