import 'package:fittrack/presentation/screens/features/sleep/sleep_statistics_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'bloc/sleep_bloc.dart';
import 'bloc/sleep_event.dart';
import 'bloc/sleep_state.dart';
import 'add_sleep_info_screen.dart';

class SleepInfoScreen extends StatefulWidget {
  const SleepInfoScreen({super.key});

  @override
  State<SleepInfoScreen> createState() => _SleepInfoScreenState();
}

class _SleepInfoScreenState extends State<SleepInfoScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime startOfWeek = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    getStartOfWeek(selectedDate);
    _loadSleepData();
    _scrollController.addListener(_toggleFabVisibility);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_toggleFabVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleFabVisibility() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse && _isFabVisible) {
      setState(() {
        _isFabVisible = false;
      });
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward && !_isFabVisible) {
      setState(() {
        _isFabVisible = true;
      });
    }
  }

  void getStartOfWeek(DateTime date) {
    startOfWeek = date.subtract(Duration(days: date.weekday - 1));
  }

  void _selectDateDay(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    _loadSleepData();
  }

  void _loadSleepData() {
    final date = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    context.read<SleepBloc>().add(SleepFetchForDate(date));
  }

  void _goToPreviousWeek() {
    setState(() {
      startOfWeek = startOfWeek.subtract(const Duration(days: 7));
      selectedDate = startOfWeek;
    });
    _loadSleepData();
  }

  void _goToNextWeek() {
    setState(() {
      startOfWeek = startOfWeek.add(const Duration(days: 7));
      selectedDate = startOfWeek;
    });
    _loadSleepData();
  }

  String getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'ПН';
      case 2:
        return 'ВТ';
      case 3:
        return 'СР';
      case 4:
        return 'ЧТ';
      case 5:
        return 'ПТ';
      case 6:
        return 'СБ';
      case 7:
        return 'НД';
      default:
        return '';
    }
  }

  // Function to determine FAB visibility based on state
  bool _shouldShowFab(SleepState state) {
    if (state.status == SleepStatus.loading) {
      return false;
    } else if ((state.sleepEntry != null &&
        state.sleepEntry!.wakeUpTime.day == selectedDate.day &&
        state.sleepEntry!.wakeUpTime.month == selectedDate.month &&
        state.sleepEntry!.wakeUpTime.year == selectedDate.year)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text('Сон'),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/statistic_icon.svg",
              height: 20,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SleepStatisticsScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
        child: Column(
          children: [
            // Week selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _goToPreviousWeek,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Icon(
                      CupertinoIcons.chevron_back,
                      color: Theme.of(context).brightness == Brightness.light
                          ? const Color(0xFF8C8C8C)
                          : Theme.of(context).hintColor,
                      size: 24.0,
                    ),
                  ),
                ),
                Text(
                  '${startOfWeek.day} - ${startOfWeek.add(const Duration(days: 6)).day}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                GestureDetector(
                  onTap: _goToNextWeek,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Icon(
                      CupertinoIcons.chevron_forward,
                      color: Theme.of(context).brightness == Brightness.light
                          ? const Color(0xFF8C8C8C)
                          : Theme.of(context).hintColor,
                      size: 24.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Days of week
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  DateTime currentDate = startOfWeek.add(Duration(days: index));
                  bool isSelected = currentDate.day == selectedDate.day &&
                      currentDate.month == selectedDate.month &&
                      currentDate.year == selectedDate.year;

                  return GestureDetector(
                    onTap: () => _selectDateDay(currentDate),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      width: isSelected ? 60.0 : 40.0,
                      height: 60.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getDayName(currentDate.weekday),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Theme.of(context).hintColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            '${currentDate.day}',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Theme.of(context).brightness == Brightness.light
                                  ? const Color(0xFF8C8C8C)
                                  : Theme.of(context).hintColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            // Sleep data
            Expanded(
              child: BlocBuilder<SleepBloc, SleepState>(
                builder: (context, state) {
                  if (state.status == SleepStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == SleepStatus.error) {
                    return Center(
                      child: Text('Помилка: ${state.errorMessage}'),
                    );
                  } else if (state.sleepEntry != null &&
                      state.sleepEntry!.wakeUpTime.day == selectedDate.day &&
                      state.sleepEntry!.wakeUpTime.month == selectedDate.month &&
                      state.sleepEntry!.wakeUpTime.year == selectedDate.year) {
                    return Column(
                      children: [
                        // Sleep hours card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.nightlight_round,
                                    color: Theme.of(context).primaryColor,
                                    size: 36,
                                  ),
                                  const SizedBox(width: 16),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${state.formattedHours} год ${state.formattedMinutes} хв\n',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.bodyLarge?.color,
                                          ),
                                        ),

                                        TextSpan(
                                          text: '${state.sleepEntry!.sleepStart.hour}:${state.sleepEntry!.sleepStart.minute.toString().padLeft(2, '0')} - '
                                              '${state.sleepEntry!.wakeUpTime.hour}:${state.sleepEntry!.wakeUpTime.minute.toString().padLeft(2, '0')}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => AddSleepInfoScreen(
                                        initialSleepStart: state.sleepEntry!.sleepStart,
                                        initialWakeUpTime: state.sleepEntry!.wakeUpTime,
                                        date: selectedDate,
                                      ),
                                    ),
                                  ).then((_) => _loadSleepData());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(26))
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(Icons.settings, color: Theme.of(context).scaffoldBackgroundColor, size: 30,)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Sleep time details
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              // Sleep cycle visualization
                              SizedBox(
                                height: 120,
                                child: CustomPaint(
                                  size: Size(MediaQuery.of(context).size.width - 64, 120),
                                  painter: SleepCyclePainter(
                                    startTime: state.sleepEntry!.sleepStart,
                                    endTime: state.sleepEntry!.wakeUpTime,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${state.sleepEntry!.sleepStart.hour}:${state.sleepEntry!.sleepStart.minute.toString().padLeft(2, '0')} ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  Text(
                                    '${state.sleepEntry!.wakeUpTime.hour}:${state.sleepEntry!.wakeUpTime.minute.toString().padLeft(2, '0')} ',
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
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.nightlight_round,
                          color: Theme.of(context).primaryColor,
                          size: 32,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Немає даних про сон',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Додайте інформацію про свій сон',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<SleepBloc, SleepState>(
        builder: (context, state) {
          final shouldShow = _shouldShowFab(state) && _isFabVisible;

          return AnimatedOpacity(
            opacity: shouldShow ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 400),
            child: FloatingActionButton(
              onPressed: shouldShow ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddSleepInfoScreen(date: selectedDate),
                  ),
                ).then((_) => _loadSleepData());
              } : null,
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.add, color: Theme.of(context).scaffoldBackgroundColor),
            ),
          );
        },
      ),
    );
  }
}