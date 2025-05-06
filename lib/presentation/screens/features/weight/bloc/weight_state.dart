import 'package:equatable/equatable.dart';

import '../../../../../data/models/weight_model.dart';

abstract class WeightState extends Equatable {
  const WeightState();

  @override
  List<Object?> get props => [];
}

class WeightInitial extends WeightState {}

class WeightLoading extends WeightState {}

class WeightsLoaded extends WeightState {
  final List<WeightModel> weights;

  const WeightsLoaded(this.weights);

  @override
  List<Object?> get props => [weights];
}

class LatestWeightLoaded extends WeightState {
  final WeightModel? weight;
  final List<WeightModel>? weights;

  const LatestWeightLoaded(this.weight, {this.weights});

  @override
  List<Object?> get props => [weight, weights];
}

class MonthlyChangeLoaded extends WeightState {
  final double? change;

  const MonthlyChangeLoaded(this.change);

  @override
  List<Object?> get props => [change];
}

class WeightAdding extends WeightState {}

class WeightAdded extends WeightState {
  final WeightModel weight;

  const WeightAdded(this.weight);

  @override
  List<Object?> get props => [weight];
}

class WeightError extends WeightState {
  final String message;

  const WeightError(this.message);

  @override
  List<Object?> get props => [message];
}