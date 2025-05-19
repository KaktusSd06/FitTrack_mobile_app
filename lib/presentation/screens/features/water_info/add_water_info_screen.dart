import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/water_bloc.dart';
import 'bloc/water_event.dart';
import 'bloc/water_state.dart';

class AddWaterInfoScreen extends StatefulWidget {
  final double currentWater;
  const AddWaterInfoScreen({super.key, required this.currentWater});

  @override
  State<AddWaterInfoScreen> createState() => _AddWaterInfoScreenState();
}

class _AddWaterInfoScreenState extends State<AddWaterInfoScreen> {
  int _currentValue = 150;

  final int _minValue = 50;
  final int _maxValue = 4000;
  final int _step = 10;

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
          'Додати воду',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: BlocListener<WaterBloc, WaterState>(
        listener: (context, state) {
          if (state is WaterLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Воду додано успішно'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme.of(context).primaryColor,
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 2),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.of(context).pop();
            });
          } else if (state is WaterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Помилка: ${state.message}'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 3),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      'Вода (Мл)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
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
                          child: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).hintColor, size: 24),
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
                                      ? (Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                      : Theme.of(context).hintColor,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: BlocBuilder<WaterBloc, WaterState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        disabledBackgroundColor: Colors.blue.withOpacity(0.6),
                      ),
                      onPressed: state is WaterUpdating
                          ? null
                          : () {
                        context.read<WaterBloc>().add(
                          AddWaterIntake(
                            date: DateTime.now(),
                            volumeMl: (_currentValue + widget.currentWater.toInt()),
                          ),
                        );
                      },
                      child: state is WaterUpdating
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : const Text(
                        'Додати воду',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}