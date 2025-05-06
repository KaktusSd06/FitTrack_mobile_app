import 'package:equatable/equatable.dart';

abstract class PageWithIndicatorsState extends Equatable {
  const PageWithIndicatorsState();

  @override
  List<Object?> get props => [];
}

class PageWithIndicatorsInitial extends PageWithIndicatorsState {}

class PageWithIndicatorsLoading extends PageWithIndicatorsState {}

class PageWithIndicatorsLoaded extends PageWithIndicatorsState {
  final double kcalToday;
  final double goal;
  final double weight;

  const PageWithIndicatorsLoaded({required this.kcalToday, required this.goal, required this.weight});

  @override
  List<Object?> get props => [kcalToday];
}

class PageWithIndicatorsCreated extends PageWithIndicatorsState {}

class PageWithIndicatorsError extends PageWithIndicatorsState {
  final String message;

  const PageWithIndicatorsError({required this.message});

  @override
  List<Object?> get props => [message];
}