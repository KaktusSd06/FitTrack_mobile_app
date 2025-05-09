import 'package:equatable/equatable.dart';
import '../../../../../data/models/water_intake_model.dart';

abstract class WaterState extends Equatable {
  const WaterState();

  @override
  List<Object?> get props => [];
}

/// Початковий стан
class WaterInitial extends WaterState {}

/// Стан завантаження даних
class WaterLoading extends WaterState {}

/// Стан оновлення даних
class WaterUpdating extends WaterState {}

/// Стан успішного завантаження даних
class WaterLoaded extends WaterState {
  final WaterIntake? waterIntake;

  const WaterLoaded({this.waterIntake});

  @override
  List<Object?> get props => [waterIntake];
}

/// Стан помилки
class WaterError extends WaterState {
  final String message;

  const WaterError({required this.message});

  @override
  List<Object> get props => [message];
}