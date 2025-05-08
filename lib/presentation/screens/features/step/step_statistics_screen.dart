import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../../data/constants/calories_group_by.dart';
// Import with alias to avoid name conflict with Flutter's StepState
import 'bloc/step_bloc.dart';
import 'bloc/step_event.dart';
import 'bloc/step_state.dart' as app_step;

class StepStatisticsScreen extends StatefulWidget {
  const StepStatisticsScreen({super.key});

  @override
  State<StepStatisticsScreen> createState() => _StepStatisticsScreenState();
}

class _StepStatisticsScreenState extends State<StepStatisticsScreen> {
  PeriodType _selectedPeriod = PeriodType.day;
  // Add a new variable to track the currently selected date range type
  DateRangeType _selectedDateRange = DateRangeType.sevenDays;

  @override
  void initState() {
    super.initState();
    _loadDataForSelectedPeriod();
  }

  void _loadDataForSelectedPeriod() {
    final now = DateTime.now();
    DateTime fromDate;
    DateTime toDate = now;

    switch (_selectedPeriod) {
      case PeriodType.day:
        fromDate = DateTime(now.year, now.month, now.day - 6);
        break;
      case PeriodType.month:
        fromDate = DateTime(now.year - 1, now.month, now.day);
        break;
    }

    context.read<StepBloc>().add(
      FetchStepsByPeriod(
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
        title: Text('Кроки', style: Theme.of(context).textTheme.displayMedium,),
      ),
      body: BlocBuilder<StepBloc, app_step.StepState>(
        builder: (context, state) {
          if (state is app_step.StepLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is app_step.StepError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is app_step.StepLoaded) {
            return _buildStatisticsContent(context, state);
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildStatisticsContent(BuildContext context, app_step.StepLoaded state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPeriodSelector(context, state),
          const SizedBox(height: 16),
          _buildSummaryCard(context, state),
          const SizedBox(height: 16),
          _buildStepChart(context, state),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context, app_step.StepLoaded state) {
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
      _selectedPeriod = PeriodType.day;
      _selectedDateRange = DateRangeType.sevenDays;
    });

    context.read<StepBloc>().add(
      FetchStepsByPeriod(
        fromDate: DateTime.now().subtract(const Duration(days: 6)),
        toDate: DateTime.now(),
      ),
    );
  }

  void _selectMonth(BuildContext context) {
    setState(() {
      _selectedPeriod = PeriodType.day;
      _selectedDateRange = DateRangeType.thirtyOneDays;
    });

    context.read<StepBloc>().add(
      FetchStepsByPeriod(
        fromDate: DateTime.now().subtract(const Duration(days: 30)),
        toDate: DateTime.now(),
      ),
    );
  }


  Widget _buildSummaryCard(BuildContext context, app_step.StepLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${state.dailySteps} кроків за день',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Середнє: ${(state.totalStepsInPeriod / (state.steps.isNotEmpty ? state.steps.length : 1)).round()}',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                Text(
                  '${state.distance.toStringAsFixed(2)} км',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ціль на день: ${state.goalSteps}',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                Text(
                  'Ціль виконано: ${_calculateGoalCompletion(state)}',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _calculateGoalCompletion(app_step.StepLoaded state) {
    final completedDays = state.steps.where((step) => step.steps >= state.goalSteps).length;
    final totalDays = state.steps.length;
    return '$completedDays/$totalDays';
  }

  Widget _buildStepChart(BuildContext context, app_step.StepLoaded state) {
    // Create data for bar chart
    final barGroups = _createBarGroups(state);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 300,
        child: barGroups.isEmpty
            ? const Center(child: Text('Здається треба почати більше ходити :)'))
            : BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _getMaxSteps(state) * 1.2,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY.round()} кроків',
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
                    if (value < 0 || value >= state.steps.length) {
                      return const SizedBox();
                    }

                    final index = value.toInt();
                    if (index >= state.steps.length) return const SizedBox();

                    final date = state.steps[index].date;
                    return Text(
                      _formatDateLabel(date, _selectedPeriod),
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
                    if (value % 2000 == 0) {
                      return Text(
                        '${value.toInt()}',
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
              horizontalInterval: 100,
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

  List<BarChartGroupData> _createBarGroups(app_step.StepLoaded state) {
    final goalValue = state.goalSteps.toDouble();

    return state.steps.asMap().entries.map((entry) {
      final index = entry.key;
      final stepInfo = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: stepInfo.steps.toDouble(),
            color: stepInfo.steps >= goalValue ? Theme.of(context).primaryColor : Colors.grey,
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

  double _getMaxSteps(app_step.StepLoaded state) {
    if (state.steps.isEmpty) return 10000;

    return state.steps
        .map((step) => step.steps.toDouble())
        .reduce((max, steps) => steps > max ? steps : max);
  }

  String _formatDateLabel(DateTime date, PeriodType periodType) {
    switch (periodType) {
      case PeriodType.day:
        return DateFormat('dd/MM').format(date);
      case PeriodType.month:
        return DateFormat('MMM').format(date);
    }
  }
}

enum DateRangeType {
  sevenDays,
  thirtyOneDays,
  year,
}