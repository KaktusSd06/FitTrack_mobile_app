import 'package:equatable/equatable.dart';

abstract class WeightEvent extends Equatable {
  const WeightEvent();

  @override
  List<Object?> get props => [];
}

class LoadWeights extends WeightEvent {
  final DateTime from;
  final DateTime to;

  const LoadWeights({required this.from, required this.to});

  @override
  List<Object?> get props => [from, to];
}

class AddWeight extends WeightEvent {
  final double weightKg;
  final DateTime date;

  const AddWeight({required this.weightKg, required this.date});

  @override
  List<Object?> get props => [weightKg, date];
}

class LoadLatestWeight extends WeightEvent {}

class LoadMonthlyChange extends WeightEvent {}