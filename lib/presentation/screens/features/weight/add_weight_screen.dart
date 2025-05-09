import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/weight_bloc.dart';
import 'bloc/weight_event.dart';
import 'bloc/weight_state.dart';

class AddWeightScreen extends StatefulWidget {
  const AddWeightScreen({super.key});

  @override
  State<AddWeightScreen> createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends State<AddWeightScreen> {
  double _currentValue = 70.0;
  final double _minValue = 40.0;
  final double _maxValue = 150.0;
  final double _step = 0.1;

  late final FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final state = context.read<WeightBloc>().state;
    if (state is LatestWeightLoaded && state.weight != null) {
      _currentValue = state.weight!.weightKg;
    }

    int initialPosition = ((_currentValue - _minValue) / _step).round();
    _scrollController = FixedExtentScrollController(initialItem: initialPosition);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int get _itemCount => ((_maxValue - _minValue) / _step).round() + 1;

  double _getValueForPosition(int position) {
    return _minValue + (position * _step);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeightBloc, WeightState>(
      listener: (context, state) {
        if (state is WeightAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Показник успішно додано'),
              backgroundColor: Theme.of(context).primaryColor,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          Navigator.of(context).pop();
        } else if (state is WeightError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Помилка збереження'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Додати запис',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
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
                      child: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).hintColor, size: 24),
                    ),
                    ListWheelScrollView(
                      controller: _scrollController,
                      itemExtent: 40,
                      physics: const FixedExtentScrollPhysics(),
                      diameterRatio: 0.8,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          _currentValue = _getValueForPosition(index);
                        });
                      },
                      children: List.generate(_itemCount, (index) {
                        final value = _getValueForPosition(index);
                        return Center(
                          child: Text(
                            value.toStringAsFixed(1),
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
                child: BlocBuilder<WeightBloc, WeightState>(
                  buildWhen: (previous, current) => current is WeightAdding || current is WeightError,
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: state is WeightAdding
                          ? null
                          : () {
                        context.read<WeightBloc>().add(
                          AddWeight(
                            weightKg: _currentValue,
                            date: DateTime.now(),
                          ),
                        );
                      },
                      child: state is WeightAdding
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'Додати',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}