import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../core/config/secure_storage_keys.dart';
import '../../../../../data/services/water_service.dart';
import 'water_event.dart';
import 'water_state.dart';

class WaterBloc extends Bloc<WaterEvent, WaterState> {
  final WaterService _waterService;
  final secureStorage = const FlutterSecureStorage();

  WaterBloc({required WaterService waterService})
      : _waterService = waterService,
        super(WaterInitial()) {
    on<FetchTodayWaterIntake>(_onFetchTodayWaterIntake);
    on<AddWaterIntake>(_onAddWaterIntake);
  }

  Future<void> _onFetchTodayWaterIntake(
      FetchTodayWaterIntake event,
      Emitter<WaterState> emit,
      ) async {
    try {
      emit(WaterLoading());

      final today = DateTime.now();
      final waterIntake = await _waterService.getWaterIntakeByUserAndDate(today);

      if (waterIntake != null) {
        emit(WaterLoaded(waterIntake: waterIntake));
      } else {
        emit(const WaterLoaded(waterIntake: null));
      }
    } catch (e) {
      emit(WaterError(message: e.toString()));
    }
  }

  Future<void> _onAddWaterIntake(
      AddWaterIntake event,
      Emitter<WaterState> emit,
      ) async {
    try {
      emit(WaterUpdating());

      final userId = await secureStorage.read(key: SecureStorageKeys.userId);

      if (userId == null) {
        emit(const WaterError(message: 'Користувача не знайдено'));
        return;
      }

      await _waterService.upsertWaterIntake(
        userId: userId,
        date: event.date,
        volumeMl: event.volumeMl,
      );

      // Перезавантажуємо дані після оновлення
      final updatedWaterIntake = await _waterService.getWaterIntakeByUserAndDate(event.date);
      emit(WaterLoaded(waterIntake: updatedWaterIntake));
    } catch (e) {
      emit(WaterError(message: e.toString()));
    }
  }

  /// Повертає кількість випитої води сьогодні
  int getTodayWaterIntake() {
    if (state is WaterLoaded) {
      final loadedState = state as WaterLoaded;
      return loadedState.waterIntake?.volumeMl ?? 0;
    }
    return 0;
  }
}