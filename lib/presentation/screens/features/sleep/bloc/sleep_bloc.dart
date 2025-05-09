import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../core/config/secure_storage_keys.dart';
import '../../../../../data/services/sleep_service.dart';
import 'sleep_event.dart';
import 'sleep_state.dart';

class SleepBloc extends Bloc<SleepEvent, SleepState> {
  final SleepService _sleepService;
  final FlutterSecureStorage _secureStorage;

  SleepBloc({
    required SleepService sleepService,
    required FlutterSecureStorage secureStorage,
  })  : _sleepService = sleepService,
        _secureStorage = secureStorage,
        super(const SleepState()) {
    on<SleepFetchForDate>(_onFetchForDate);
    on<SleepAddOrUpdate>(_onAddOrUpdate);
    on<SleepTimeChanged>(_onTimeChanged);
    on<SleepReset>(_onReset);
  }

  Future<void> _onFetchForDate(
      SleepFetchForDate event,
      Emitter<SleepState> emit,
      ) async {
    emit(state.copyWith(
      status: SleepStatus.loading,
      selectedDate: event.date,
    ));

    try {
      final sleepEntry = await _sleepService.getSleepByUserAndDate(event.date);

      // Якщо запис не знайдено для вибраної дати, очищаємо попередній sleepEntry
      if (sleepEntry == null) {
        emit(state.copyWith(
          status: SleepStatus.loaded,
          sleepEntry: null,
        ));
      } else {
        emit(state.copyWith(
          status: SleepStatus.loaded,
          sleepEntry: sleepEntry,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: SleepStatus.error,
        errorMessage: 'Failed to fetch sleep data: ${e.toString()}',
      ));
    }
  }

  Future<void> _onAddOrUpdate(
      SleepAddOrUpdate event,
      Emitter<SleepState> emit,
      ) async {
    emit(state.copyWith(isSaving: true));

    try {
      final userId = await _secureStorage.read(key: SecureStorageKeys.userId);

      if (userId == null) {
        emit(state.copyWith(
          status: SleepStatus.error,
          errorMessage: 'User not authenticated',
          isSaving: false,
        ));
        return;
      }

      // Отримуємо ID поточного запису, якщо він існує і відповідає вибраній даті
      String? currentEntryId;
      if (state.sleepEntry != null &&
          state.selectedDate != null &&
          _isSameDay(state.sleepEntry!.wakeUpTime, state.selectedDate!)) {
        currentEntryId = state.sleepEntry?.id;
      }

      await _sleepService.upsertSleep(
        userId: userId,
        sleepStart: event.sleepStart,
        wakeUpTime: event.wakeUpTime,
        id: currentEntryId,
      );

      // Оновлюємо дані після збереження
      final updatedEntry = await _sleepService.getSleepByUserAndDate(event.sleepStart);

      emit(state.copyWith(
        status: SleepStatus.loaded,
        sleepEntry: updatedEntry,
        isSaving: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SleepStatus.error,
        errorMessage: 'Failed to save sleep data: ${e.toString()}',
        isSaving: false,
      ));
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }

  void _onTimeChanged(
      SleepTimeChanged event,
      Emitter<SleepState> emit,
      ) {
    if (state.sleepEntry != null) {
      final updatedEntry = state.sleepEntry!.copyWith(
        sleepStart: event.sleepStart,
        wakeUpTime: event.wakeUpTime,
      );
      emit(state.copyWith(sleepEntry: updatedEntry));
    }
  }

  void _onReset(
      SleepReset event,
      Emitter<SleepState> emit,
      ) {
    emit(const SleepState());
  }
}