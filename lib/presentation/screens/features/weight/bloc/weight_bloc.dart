import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/models/weight_model.dart';
import '../../../../../data/services/weight_service.dart';
import 'weight_event.dart';
import 'weight_state.dart';

class WeightBloc extends Bloc<WeightEvent, WeightState> {
  final WeightService _weightService;

  WeightBloc({required WeightService weightService})
      : _weightService = weightService,
        super(WeightInitial()) {
    on<LoadWeights>(_onLoadWeights);
    on<AddWeight>(_onAddWeight);
    on<LoadLatestWeight>(_onLoadLatestWeight);
    on<LoadMonthlyChange>(_onLoadMonthlyChange);
  }

  Future<void> _onLoadWeights(
      LoadWeights event,
      Emitter<WeightState> emit,
      ) async {
    emit(WeightLoading());
    try {
      final weights = await _weightService.getWeightsBetween(event.from, event.to);
      emit(WeightsLoaded(weights));
    } catch (e) {
      emit(WeightError(e.toString()));
    }
  }

  Future<void> _onAddWeight(
      AddWeight event,
      Emitter<WeightState> emit,
      ) async {
    emit(WeightAdding());
    try {
      await _weightService.addWeight(weightKg: event.weightKg, date: event.date);

      final latestWeight = await _weightService.getLatestWeight();
      if (latestWeight != null) {
        emit(WeightAdded(latestWeight));
      } else {
        emit(const WeightError("Не вдалося отримати доданий запис"));
      }
    } catch (e) {
      emit(WeightError(e.toString()));
    }
  }

  Future<void> _onLoadLatestWeight(
      LoadLatestWeight event,
      Emitter<WeightState> emit,
      ) async {
    emit(WeightLoading());
    try {
      final weight = await _weightService.getLatestWeight();

      final currentState = state;
      List<WeightModel>? currentWeights;
      if (currentState is WeightsLoaded) {
        currentWeights = currentState.weights;
      }

      emit(LatestWeightLoaded(weight, weights: currentWeights));
    } catch (e) {
      emit(WeightError(e.toString()));
    }
  }

  Future<void> _onLoadMonthlyChange(
      LoadMonthlyChange event,
      Emitter<WeightState> emit,
      ) async {
    emit(WeightLoading());
    try {
      final change = await _weightService.getChangeThisMonth();
      emit(MonthlyChangeLoaded(change));
    } catch (e) {
      emit(WeightError(e.toString()));
    }
  }
}