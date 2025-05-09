import 'package:equatable/equatable.dart';

abstract class WaterEvent extends Equatable {
  const WaterEvent();

  @override
  List<Object?> get props => [];
}

/// Подія для отримання інформації про випиту воду за сьогодні
class FetchTodayWaterIntake extends WaterEvent {
  const FetchTodayWaterIntake();
}

/// Подія для додавання або оновлення кількості випитої води
class AddWaterIntake extends WaterEvent {
  final DateTime date;
  final int volumeMl;

  const AddWaterIntake({
    required this.date,
    required this.volumeMl,
  });

  @override
  List<Object?> get props => [date, volumeMl];
}