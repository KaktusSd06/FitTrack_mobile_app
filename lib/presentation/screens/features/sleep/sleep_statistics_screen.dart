import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'bloc_chart/sleep_statistics_bloc.dart';
import 'bloc_chart/sleep_statistics_event.dart';
import 'bloc_chart/sleep_statistics_state.dart';

class SleepStatisticsScreen extends StatefulWidget {
  const SleepStatisticsScreen({super.key});

  @override
  State<SleepStatisticsScreen> createState() => _SleepStatisticsScreenState();
}

class _SleepStatisticsScreenState extends State<SleepStatisticsScreen> {
  DateRangeType _selectedDateRange = DateRangeType.sevenDays;

  @override
  void initState() {
    super.initState();
    _loadDataForSevenDays();
  }

  void _loadDataForSevenDays() {
    final now = DateTime.now();
    final fromDate = now.subtract(const Duration(days: 6));
    final toDate = now;

    context.read<SleepStatisticsBloc>().add(
      FetchSleepStatistics(
        fromDate: fromDate,
        toDate: toDate,
      ),
    );
  }

  void _loadDataForMonth() {
    final now = DateTime.now();
    final fromDate = now.subtract(const Duration(days: 30));
    final toDate = now;

    context.read<SleepStatisticsBloc>().add(
      FetchSleepStatistics(
        fromDate: fromDate,
        toDate: toDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text('Сон', style: Theme.of(context).textTheme.displayMedium,),
      ),
      body: BlocBuilder<SleepStatisticsBloc, SleepStatisticsState>(
        builder: (context, state) {
          if (state is SleepStatisticsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SleepStatisticsError) {
            return Center(child: Text('Помилка: ${state.message}'));
          } else if (state is SleepStatisticsLoaded) {
            return _buildStatisticsContent(context, state);
          }
          return const Center(child: Text('Немає доступних даних'));
        },
      ),
    );
  }

  Widget _buildStatisticsContent(BuildContext context, SleepStatisticsLoaded state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPeriodSelector(context),
          const SizedBox(height: 16),
          _buildSummaryCard(context, state),
          const SizedBox(height: 16),
          _buildSleepChart(context, state),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDateRangeButton(
            context,
            '7 днів',
            isSelected: _selectedDateRange == DateRangeType.sevenDays,
            onTap: () => _selectSevenDays(context),
          ),
          _buildDateRangeButton(
            context,
            '31 день',
            isSelected: _selectedDateRange == DateRangeType.thirtyOneDays,
            onTap: () => _selectMonth(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeButton(
      BuildContext context,
      String text, {
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).cardColor : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: isSelected ? const Offset(0, 2) : const Offset(0, 0),
              blurRadius: isSelected ? 4.0 : 0,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _selectSevenDays(BuildContext context) {
    setState(() {
      _selectedDateRange = DateRangeType.sevenDays;
    });
    _loadDataForSevenDays();
  }

  void _selectMonth(BuildContext context) {
    setState(() {
      _selectedDateRange = DateRangeType.thirtyOneDays;
    });
    _loadDataForMonth();
  }

  Widget _buildSummaryCard(BuildContext context, SleepStatisticsLoaded state) {
    final averageHours = state.statistics.averageDurationMinutes ~/ 60;
    final averageMinutes = state.statistics.averageDurationMinutes % 60;


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Середнє: $averageHours год ${averageMinutes.round()} хв',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepChart(BuildContext context, SleepStatisticsLoaded state) {
    // Create data for bar chart
    final barGroups = _createBarGroups(state);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 300,
        child: barGroups.isEmpty
            ? const Center(child: Text('Недостатньо даних про сон :('))
            : BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _getMaxSleepDuration(state) * 1.2,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final hoursValue = rod.toY / 60; // Convert minutes to hours
                  final hours = hoursValue.floor();
                  final minutes = ((hoursValue - hours) * 60).round();
                  return BarTooltipItem(
                    '$hours год $minutes хв',
                    const TextStyle(color: Colors.black),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    if (value < 0 || value >= state.statistics.sleepGrouped.length) {
                      return const SizedBox();
                    }

                    final index = value.toInt();
                    if (index >= state.statistics.sleepGrouped.length) return const SizedBox();

                    final date = state.statistics.sleepGrouped[index].date;
                    return Text(
                      DateFormat('dd/MM').format(date),
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    // Show hour markers
                    if (value % 60 == 0 && value > 0) {
                      return Text(
                        '${(value ~/ 60)} год',
                        style: const TextStyle(fontSize: 10),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              horizontalInterval: 60, // Hour intervals
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withAlpha((0.2 * 255).round()),
                  strokeWidth: 0.5,
                );
              },
              getDrawingVerticalLine: (_) => const FlLine(
                color: Colors.transparent,
              ),
            ),
            barGroups: barGroups,
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups(SleepStatisticsLoaded state) {
    const recommendedSleep = 480.0;

    return state.statistics.sleepGrouped.asMap().entries.map((entry) {
      final index = entry.key;
      final sleepInfo = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: sleepInfo.durationMinutes.toDouble(),
            color: sleepInfo.durationMinutes >= recommendedSleep
                ? Theme.of(context).primaryColor
                : Colors.grey,
            width: 14,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  double _getMaxSleepDuration(SleepStatisticsLoaded state) {
    if (state.statistics.sleepGrouped.isEmpty) return 600; // Default to 10 hours

    return state.statistics.sleepGrouped
        .map((sleep) => sleep.durationMinutes.toDouble())
        .reduce((max, duration) => duration > max ? duration : max);
  }
}

enum DateRangeType {
  sevenDays,
  thirtyOneDays,
}