import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../../../core/config/secure_storage_keys.dart';
import '../../../../../data/services/goal_service.dart';
import '../../../../../data/services/step_info_service.dart';
import '../../../../../data/constants/goal.dart';
import 'step_event.dart';
import 'step_state.dart';

class StepBloc extends Bloc<StepEvent, StepState> {
  final StepsInfoService _stepsInfoService;
  final GoalService _goalService;

  final _secureStorage = const FlutterSecureStorage();

  // Stream subscriptions for accelerometer data
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  // Timer for periodic database updates
  Timer? _dbSaveTimer;

  // Constants for step detection algorithm - These need careful tuning
  final int _stepThreshold = 10;      // Adjust based on testing
  final int _minStepIntervalMs = 200; // Minimum time between steps (ms)
  final double _strideLength = 0.762; // Average stride length in meters
  final double _caloriesPerStep = 0.04; // Average calories burned per step
  final Duration _dbSaveInterval = Duration(minutes: 10); // Save to DB every 2 hours

  int _currentDailySteps = 0;
  int _lastSavedSteps = 0;
  int _stepGoal = 8000; // Default goal
  List<double> _accelerometerValues = <double>[];
  int _lastStepTime = 0;
  int _lastPeakTime = 0;  // Keep track of the last peak time
  bool _isPeak = false;    // Track if we are currently on a peak
  DateTime _lastDbSaveTime = DateTime.now();

  StepBloc({required StepsInfoService stepsInfoService, required GoalService goalService})
      : _stepsInfoService = stepsInfoService, _goalService = goalService,
        super(StepInitial()) {
    on<FetchDailySteps>(_onFetchDailySteps);
    on<FetchStepsByPeriod>(_onFetchStepsByPeriod);
    on<UpdateSteps>(_onUpdateSteps);
    on<SetStepGoal>(_onSetStepGoal);
    on<ForceSync>(_onForceSync);

    // Initialize step counting
    _initStepCounting();
    _startPeriodicDbSave();
  }

  Future<void> _loadStepGoal() async {
    final goalValue = await _goalService.getGoalValue(goalType: Goal.steps.value);
    _stepGoal = goalValue.toInt();
    }

  void _initStepCounting() {
    _startListeningForAccelerometer();
    // Load today's steps
    final today = DateTime.now();
    add(FetchDailySteps(date: today));
  }

  void _startListeningForAccelerometer() {
    _accelerometerSubscription?.cancel(); // Cancel any existing subscription

    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      _accelerometerValues = <double>[event.x, event.y, event.z];
      _processAccelerometerData(); // Process the data for step detection
    }, onError: (error) {
      // Handle errors, e.g., device not supporting accelerometer
      print('Accelerometer error: $error');
      // Consider emitting an error state, or attempting to use a different source.
    });
  }

  void _startPeriodicDbSave() {
    // Cancel any existing timer
    _dbSaveTimer?.cancel();

    // Set up a new timer to save steps to the database every 2 hours
    _dbSaveTimer = Timer.periodic(_dbSaveInterval, (timer) {
      _saveStepsToDb();
    });
  }

  Future<void> _saveStepsToDb() async {
    if (_currentDailySteps > _lastSavedSteps) {
      await _stepsInfoService.addOrUpdateSteps(
        steps: _currentDailySteps,
        date: DateTime.now(),
      );
      _lastSavedSteps = _currentDailySteps;
      _lastDbSaveTime = DateTime.now();
    }
  }

  void _processAccelerometerData() {
    if (_accelerometerValues.isEmpty) return;

    double magnitude = sqrt(
        _accelerometerValues[0] * _accelerometerValues[0] +
            _accelerometerValues[1] * _accelerometerValues[1] +
            _accelerometerValues[2] * _accelerometerValues[2]);

    int currentTime = DateTime.now().millisecondsSinceEpoch;

    // Peak detection
    if (magnitude > _stepThreshold) {
      if (!_isPeak) { // Only count a peak once
        _isPeak = true;
        _lastPeakTime = currentTime; //record the peak time
        if (_lastPeakTime - _lastStepTime > _minStepIntervalMs) {
          _lastStepTime = _lastPeakTime; //update last step time
          _currentDailySteps++;

          // Emit event to update UI with new steps count
          // But don't save to DB every time - that will happen periodically
          add(UpdateSteps(steps: _currentDailySteps, date: DateTime.now(), saveToDb: false));

          // If it's been more than 2 hours since last save, save to DB
          if (DateTime.now().difference(_lastDbSaveTime) >= _dbSaveInterval) {
            _saveStepsToDb();
          }
        }
      }
    } else {
      _isPeak = false; // Reset peak detection
    }
  }

  double _calculateDistance(int steps) {
    return (steps * _strideLength) / 1000;
  }

  int _calculateCalories(int steps) {
    return (steps * _caloriesPerStep).round();
  }

  Future<void> _onFetchDailySteps(
      FetchDailySteps event,
      Emitter<StepState> emit,
      ) async {
    emit(StepLoading());
    try {
      _loadStepGoal();

      final startOfDay = DateTime(event.date.year, event.date.month, event.date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1)).subtract(const Duration(microseconds: 1));

      final steps = await _stepsInfoService.fetchStepsByPeriod(
        fromDate: startOfDay,
        toDate: endOfDay,
      );

      int dailySteps = 0;
      if (steps.isNotEmpty && (DateTime(steps.last.date.day) == DateTime(DateTime.now().day))) {
        dailySteps = steps.first.steps;
        if (_currentDailySteps > dailySteps) {
          dailySteps = _currentDailySteps;
        } else {
          _currentDailySteps = dailySteps;
          _lastSavedSteps = dailySteps;
        }
      } else {
        dailySteps = _currentDailySteps;
      }

      final distance = _calculateDistance(dailySteps);
      final calories = _calculateCalories(dailySteps);
      final isGoalAchieved = dailySteps >= _stepGoal;

      emit(StepLoaded(
        steps: steps.isEmpty ? [] : steps,
        dailySteps: dailySteps,
        distance: distance,
        calories: calories,
        goalSteps: _stepGoal,
        totalStepsInPeriod: dailySteps,
        averageDistance: distance,
        isGoalAchieved: isGoalAchieved,
      ));
    } catch (e) {
      emit(StepError(message: e.toString()));
    }
  }

  Future<void> _onFetchStepsByPeriod(
      FetchStepsByPeriod event,
      Emitter<StepState> emit,
      ) async {
    emit(StepLoading());

    try {
      final steps = await _stepsInfoService.fetchStepsByPeriod(
        fromDate: event.fromDate,
        toDate: event.toDate,
      );

      // Calculate stats even if steps list is empty
      final totalSteps = steps.fold<int>(0, (sum, step) => sum + step.steps);
      final totalDistance = _calculateDistance(totalSteps);
      final _ = steps.isEmpty ? 0 : totalSteps ~/ steps.length;
      final averageDistance = steps.isEmpty ? 0.0 : totalDistance / steps.length;
      final _ = _calculateCalories(totalSteps);

      // Get today's steps - either from db or current counter
      int todaySteps = 0;
      final todayEntries = steps.where((step) =>
      step.date.year == DateTime.now().year &&
          step.date.month == DateTime.now().month &&
          step.date.day == DateTime.now().day);

      if (todayEntries.isNotEmpty) {
        todaySteps = todayEntries.fold<int>(0, (sum, step) => sum + step.steps);
        // Use the highest value between DB and current counter
        todaySteps = max(todaySteps, _currentDailySteps);
      } else {
        todaySteps = _currentDailySteps;
      }

      final isGoalAchieved = todaySteps >= _stepGoal;

      emit(StepLoaded(
        steps: steps,
        dailySteps: todaySteps,
        distance: _calculateDistance(todaySteps),
        calories: _calculateCalories(todaySteps),
        goalSteps: _stepGoal,
        totalStepsInPeriod: totalSteps,
        averageDistance: averageDistance,
        isGoalAchieved: isGoalAchieved,
      ));
    } catch (e) {
      emit(StepError(message: e.toString()));
    }
  }

  Future<void> _onUpdateSteps(
      UpdateSteps event,
      Emitter<StepState> emit,
      ) async {
    try {
      // Only save to DB if explicitly requested or on significant changes
      if (event.saveToDb) {
        await _stepsInfoService.addOrUpdateSteps(
          steps: event.steps,
          date: event.date,
        );
        _lastSavedSteps = event.steps;
        _lastDbSaveTime = DateTime.now();
      }

      if (state is StepLoaded) {
        final currentState = state as StepLoaded;
        final distance = _calculateDistance(event.steps);
        final calories = _calculateCalories(event.steps);
        final isGoalAchieved = event.steps >= _stepGoal;

        emit(currentState.copyWith(
          dailySteps: event.steps,
          distance: distance,
          calories: calories,
          isGoalAchieved: isGoalAchieved,
        ));
      }
    } catch (e) {
      emit(StepError(message: e.toString()));
    }
  }

  Future<void> _onSetStepGoal(
      SetStepGoal event,
      Emitter<StepState> emit,
      ) async {
    try {
      await _secureStorage.write(
        key: SecureStorageKeys.stepGoal,
        value: event.goalSteps.toString(),
      );

      _stepGoal = event.goalSteps;

      if (state is StepLoaded) {
        final currentState = state as StepLoaded;
        final isGoalAchieved = currentState.dailySteps >= event.goalSteps;

        emit(currentState.copyWith(
          goalSteps: event.goalSteps,
          isGoalAchieved: isGoalAchieved,
        ));
      }
    } catch (e) {
      emit(StepError(message: e.toString()));
    }
  }

  Future<void> _onForceSync(
      ForceSync event,
      Emitter<StepState> emit,
      ) async {
    try {
      await _saveStepsToDb();

      // Refresh the UI with latest data
      add(FetchDailySteps(date: DateTime.now()));
    } catch (e) {
      emit(StepError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _accelerometerSubscription?.cancel();
    _dbSaveTimer?.cancel();
    return super.close();
  }
}