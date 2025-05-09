import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Додамо імпорти для блоку і пов'язаних класів
import 'package:fittrack/presentation/screens/features/goal/bloc/goal_bloc.dart';
import 'package:fittrack/presentation/screens/features/goal/bloc/goal_event.dart';
import 'package:fittrack/presentation/screens/features/goal/bloc/goal_state.dart';

import '../../../../data/constants/goal.dart';

class CalorieGoalScreen extends StatefulWidget {
  const CalorieGoalScreen({super.key});

  @override
  State<CalorieGoalScreen> createState() => _CalorieGoalScreenState();
}

class _CalorieGoalScreenState extends State<CalorieGoalScreen> {
  int _currentValue = 2500;

  final int _minValue = 1500;
  final int _maxValue = 10000;

  final int _step = 100;

  late final FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    int initialPosition = (_currentValue - _minValue) ~/ _step;
    _scrollController = FixedExtentScrollController(initialItem: initialPosition);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int get _itemCount => (_maxValue - _minValue) ~/ _step + 1;

  int _getValueForPosition(int position) {
    return _minValue + (position * _step);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          'Встановити ціль',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: BlocConsumer<GoalBloc, GoalState>(
        listener: (context, state) {
          if (state is GoalAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Ціль змінено'),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            Navigator.of(context).pop();
          } else if (state is GoalError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Помилка встановлення цілі, спробуйте пізніше'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,

                margin: const EdgeInsets.all(16),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'kcal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 10,
                        child: Icon(Icons.keyboard_arrow_up, color: Theme.of(context).hintColor, size: 24),
                      ),
                      Positioned(
                        bottom: 10,
                        child: Icon(Icons.keyboard_arrow_down, color:  Theme.of(context).hintColor, size: 24),
                      ),
                      ListWheelScrollView(
                        controller: _scrollController,
                        itemExtent: 40,
                        physics: const FixedExtentScrollPhysics(),
                        diameterRatio: 0.9,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            _currentValue = _getValueForPosition(index);
                          });
                        },
                        children: List.generate(_itemCount, (index) {
                          final value = _getValueForPosition(index);
                          return Center(
                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                fontSize: value == _currentValue ? 24 : 18,
                                fontWeight: value == _currentValue
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: value == _currentValue
                                    ? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)
                                    : Theme.of(context).hintColor,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: state is GoalAdding
                        ? null
                        : () {
                      context.read<GoalBloc>().add(
                        CreateGoalByType(
                          value: _currentValue,
                          goalType: Goal.calories.value,
                        ),
                      );
                    },
                    child: state is GoalAdding
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      'Встановити ціль',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}