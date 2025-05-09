import 'package:equatable/equatable.dart';

abstract class SleepEvent extends Equatable {
  const SleepEvent();

  @override
  List<Object?> get props => [];
}

class SleepFetchForDate extends SleepEvent {
  final DateTime date;

  const SleepFetchForDate(this.date);

  @override
  List<Object?> get props => [date];
}

class SleepAddOrUpdate extends SleepEvent {
  final DateTime sleepStart;
  final DateTime wakeUpTime;

  const SleepAddOrUpdate({
    required this.sleepStart,
    required this.wakeUpTime,
  });

  @override
  List<Object?> get props => [sleepStart, wakeUpTime];
}

class SleepTimeChanged extends SleepEvent {
  final DateTime sleepStart;
  final DateTime wakeUpTime;

  const SleepTimeChanged({
    required this.sleepStart,
    required this.wakeUpTime,
  });

  @override
  List<Object?> get props => [sleepStart, wakeUpTime];
}

class SleepReset extends SleepEvent {}