import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'bloc/sleep_bloc.dart';
import 'bloc/sleep_event.dart';
import 'bloc/sleep_state.dart';

class AddSleepInfoScreen extends StatefulWidget {
  final DateTime date;
  final DateTime? initialSleepStart;
  final DateTime? initialWakeUpTime;

  const AddSleepInfoScreen({
    super.key,
    required this.date,
    this.initialSleepStart,
    this.initialWakeUpTime,
  });

  @override
  State<AddSleepInfoScreen> createState() => _AddSleepInfoScreenState();
}

class _AddSleepInfoScreenState extends State<AddSleepInfoScreen> {
  late DateTime _selectedDate;
  late DateTime _sleepTime;
  late DateTime _wakeUpTime;
  late double _sleepDuration;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date;
    _isEditing = widget.initialSleepStart != null && widget.initialWakeUpTime != null;

    if (_isEditing) {
      _sleepTime = widget.initialSleepStart!;
      _wakeUpTime = widget.initialWakeUpTime!;
    } else {
      // Default times if not editing
      _sleepTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          22, 0
      ); // Default 10:00 PM

      // Wake up the next day
      _wakeUpTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day + 1,
          6, 0
      ); // Default 6:00 AM
    }

    _calculateSleepDuration();
  }

  void _calculateSleepDuration() {
    final difference = _wakeUpTime.difference(_sleepTime);
    _sleepDuration = difference.inMinutes / 60.0;
  }

  Future<void> _selectSleepTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_sleepTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _sleepTime = DateTime(
          _sleepTime.year,
          _sleepTime.month,
          _sleepTime.day,
          picked.hour,
          picked.minute,
        );
        _calculateSleepDuration();
      });
    }
  }

  Future<void> _selectWakeUpTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_wakeUpTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _wakeUpTime = DateTime(
          _wakeUpTime.year,
          _wakeUpTime.month,
          _wakeUpTime.day,
          picked.hour,
          picked.minute,
        );
        _calculateSleepDuration();
      });
    }
  }

  void _saveSleepData() {
    context.read<SleepBloc>().add(
      SleepAddOrUpdate(
        sleepStart: _sleepTime,
        wakeUpTime: _wakeUpTime,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(_isEditing ? 'Редагувати сон' : 'Додати сон'),
        actions: [
          TextButton(
            onPressed: _saveSleepData,
            child: Text(
              'Зберегти',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<SleepBloc, SleepState>(
        listener: (context, state) {
          if (state.status == SleepStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Помилка збереження даних')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Дата',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('dd.MM.yyyy').format(_selectedDate),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Time selectors
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => _selectSleepTime(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Час сну',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${_sleepTime.hour}:${_sleepTime.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Theme.of(context).hintColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: Theme.of(context).dividerColor),
                    InkWell(
                      onTap: () => _selectWakeUpTime(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Час пробудження',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${_wakeUpTime.hour}:${_wakeUpTime.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Theme.of(context).hintColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sleep visualization
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.nightlight_round,
                              color: Theme.of(context).primaryColor,
                              size: 32,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Тривалість сну',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withAlpha((0.1 * 255).round()),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_sleepDuration.floor()} год ${((_sleepDuration - _sleepDuration.floor()) * 60).round()} хв',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Sleep cycle visualization
                    SizedBox(
                      height: 120,
                      child: CustomPaint(
                        size: Size(MediaQuery.of(context).size.width - 64, 120),
                        painter: SleepCyclePainter(
                          startTime: _sleepTime,
                          endTime: _wakeUpTime,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_sleepTime.hour}:${_sleepTime.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        Text(
                          '${_wakeUpTime.hour}:${_wakeUpTime.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SleepCyclePainter extends CustomPainter {
  final DateTime startTime;
  final DateTime endTime;
  final Color color;

  SleepCyclePainter({
    required this.startTime,
    required this.endTime,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withAlpha((0.1 * 255).round())
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw the background
    final Path path = Path();

    // Calculate total duration in minutes for scaling
    final double totalMinutes = endTime.difference(startTime).inMinutes.toDouble();
    final double width = size.width;
    final double height = size.height;

    // Starting point
    path.moveTo(0, height);

    // Create wave pattern for sleep cycles
    final int numCycles = (totalMinutes / 90).ceil(); // Approx. 90 min per sleep cycle
    final double cycleWidth = width / numCycles;

    // First point is high (awake)
    path.lineTo(0, height * 0.1);

    // Create sleep cycles (REM cycles)
    for (int i = 0; i < numCycles; i++) {
      // Deep sleep
      path.cubicTo(
          cycleWidth * i + cycleWidth * 0.3,
          height * 0.8,
          cycleWidth * i + cycleWidth * 0.7,
          height * 0.8,
          cycleWidth * (i + 1),
          i == numCycles - 1 ? height * 0.1 : height * 0.4
      );
    }

    // End at bottom right
    path.lineTo(width, height);
    path.close();

    // Fill the path
    canvas.drawPath(path, paint);

    // Draw the line on top of the fill
    final Path linePath = Path();
    linePath.moveTo(0, height * 0.1);
    for (int i = 0; i < numCycles; i++) {
      linePath.cubicTo(
          cycleWidth * i + cycleWidth * 0.3,
          height * 0.8,
          cycleWidth * i + cycleWidth * 0.7,
          height * 0.8,
          cycleWidth * (i + 1),
          i == numCycles - 1 ? height * 0.1 : height * 0.4
      );
    }
    canvas.drawPath(linePath, linePaint);

    // Draw moon icon at start
    final moonPaint = Paint()
      ..color = color;
    canvas.drawCircle(Offset(10, height * 0.1), 8, moonPaint);

    // Draw sun icon at end
    final sunPaint = Paint()
      ..color = color;
    canvas.drawCircle(Offset(width - 10, height * 0.1), 8, sunPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}