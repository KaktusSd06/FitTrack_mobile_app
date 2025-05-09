import 'package:equatable/equatable.dart';
import '../../../../../data/models/sleep_entry_model.dart';

enum SleepStatus { initial, loading, loaded, error }

class SleepState extends Equatable {
  final SleepStatus status;
  final SleepEntry? sleepEntry;
  final DateTime? selectedDate;
  final String? errorMessage;
  final bool isSaving;

  const SleepState({
    this.status = SleepStatus.initial,
    this.sleepEntry,
    this.selectedDate,
    this.errorMessage,
    this.isSaving = false,
  });

  SleepState copyWith({
    SleepStatus? status,
    SleepEntry? sleepEntry,
    DateTime? selectedDate,
    String? errorMessage,
    bool? isSaving,
  }) {
    return SleepState(
      status: status ?? this.status,
      sleepEntry: sleepEntry ?? this.sleepEntry,
      selectedDate: selectedDate ?? this.selectedDate,
      errorMessage: errorMessage ?? this.errorMessage,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  double get sleepDuration {
    if (sleepEntry == null) return 0.0;

    final difference = sleepEntry!.wakeUpTime.difference(sleepEntry!.sleepStart);
    return difference.inMinutes / 60.0;
  }

  String get formattedHours {
    final hours = sleepDuration.floor();
    return hours.toString();
  }

  String get formattedMinutes {
    final totalMinutes = (sleepDuration * 60).round();
    final minutes = totalMinutes % 60;
    return minutes.toString().padLeft(2, '0');
  }

  @override
  List<Object?> get props => [status, sleepEntry, selectedDate, errorMessage, isSaving];
}