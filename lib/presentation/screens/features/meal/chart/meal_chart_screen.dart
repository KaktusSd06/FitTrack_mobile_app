import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../../data/constants/calories_group_by.dart';
import '../../../../../data/services/calories_statistics_service.dart';
import 'bloc/meal_chart_bloc.dart';
import 'bloc/meal_chart_event.dart';
import 'bloc/meal_chart_state.dart';

class MealChartScreen extends StatelessWidget {

  const MealChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MealChartBloc(
        statisticsService: CaloriesStatisticsService(),
      )..add(
        LoadMealChartData(
          fromDate: DateTime.now().subtract(const Duration(days: 7)),
          toDate: DateTime.now(),
          groupBy: PeriodType.day,
        ),
      ),
      child: const MealChartView(),
    );
  }
}

class MealChartView extends StatelessWidget {
  const MealChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Харчування'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: BlocBuilder<MealChartBloc, MealChartState>(
        builder: (context, state) {
          if (state is MealChartInitial || state is MealChartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MealChartError) {
            return Center(
              child: SvgPicture.asset(
                "assets/images/error.svg",
                width: 152,
                height: 152,
              ),
            );
          } else if (state is MealChartLoaded) {
            return _buildLoadedContent(context, state);
          }
          return Center(
            child: SvgPicture.asset(
              "assets/images/error.svg",
              width: 152,
              height: 152,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadedContent(BuildContext context, MealChartLoaded state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateRangeSelector(context, state),
            const SizedBox(height: 24),
            _buildAverageCaloriesCard(state, context),
            const SizedBox(height: 24),
            _buildCaloriesChart(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector(BuildContext context, MealChartLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDateRangeButton(
          context,
          '7 днів',
          isSelected: _isSevenDaysSelected(state),
          onTap: () => _selectSevenDays(context),
        ),
        _buildDateRangeButton(
          context,
          '31 день',
          isSelected: _isMonthSelected(state),
          onTap: () => _selectMonth(context),
        ),
        _buildDateRangeButton(
          context,
          '12 міс.',
          isSelected: _isYearSelected(state),
          onTap: () => _selectYear(context),
        ),
      ],
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

  bool _isSevenDaysSelected(MealChartLoaded state) {
    final difference = state.toDate.difference(state.fromDate).inDays;
    return difference == 6;
  }

  bool _isMonthSelected(MealChartLoaded state) {
    final difference = state.toDate.difference(state.fromDate).inDays;
    return difference == 30;
  }

  bool _isYearSelected(MealChartLoaded state) {
    return state.groupBy == PeriodType.month;
  }

  void _selectSevenDays(BuildContext context) {
    context.read<MealChartBloc>().add(
      ChangeDateRange(
        fromDate: DateTime.now().subtract(const Duration(days: 6)),
        toDate: DateTime.now(),
      ),
    );

    if (_isYearSelected(context.read<MealChartBloc>().state as MealChartLoaded)) {
      context.read<MealChartBloc>().add(
        ChangeGroupBy(groupBy: PeriodType.day),
      );
    }
  }

  void _selectMonth(BuildContext context) {
    context.read<MealChartBloc>().add(
      ChangeDateRange(
        fromDate: DateTime.now().subtract(const Duration(days: 30)),
        toDate: DateTime.now(),
      ),
    );

    if (_isYearSelected(context.read<MealChartBloc>().state as MealChartLoaded)) {
      context.read<MealChartBloc>().add(
        ChangeGroupBy(groupBy: PeriodType.day),
      );
    }
  }

  void _selectYear(BuildContext context) {
    final now = DateTime.now();
    context.read<MealChartBloc>().add(
      ChangeDateRange(
        fromDate: DateTime(now.year - 1, now.month, now.day),
        toDate: now,
      ),
    );

    context.read<MealChartBloc>().add(
      ChangeGroupBy(groupBy: PeriodType.month),
    );
  }

  Widget _buildAverageCaloriesCard(MealChartLoaded state, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${state.statistics.averageCalories.toStringAsFixed(1)} kcal',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),
          Text(
            'Середня кількість',
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesChart(BuildContext context, MealChartLoaded state) {
    final items = state.statistics.items;
    if (items.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final maxCalories = items
        .map((item) => item.totalCalories)
        .reduce((value, element) => value > element ? value : element);

    const targetCalories = 2000; // Example target line

    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxCalories * 1.2,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${items[groupIndex].totalCalories} kcal',
                    const TextStyle(color: Colors.black),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value < 0 || value >= items.length) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _formatPeriodLabel(items[value.toInt()].period, state.groupBy),
                        style: const TextStyle(fontSize: 6),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return const SizedBox();
                    if (value == targetCalories) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          '${targetCalories.toInt()}',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }
                    if (value % 500 == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          '${value.toInt()}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              horizontalInterval: 500,
              getDrawingHorizontalLine: (value) {
                if (value == targetCalories) {
                  return const FlLine(
                    color: Colors.orange,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                }
                return FlLine(
                  color: Colors.grey.withAlpha((0.2 * 255).round()),
                  strokeWidth: 0.5,
                );
              },
              getDrawingVerticalLine: (_) => const FlLine(
                color: Colors.transparent,
              ),
            ),
            barGroups: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              final color = item.totalCalories >= targetCalories
                  ? Colors.orange
                  : Colors.grey.withAlpha((0.5 * 255).round());

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: item.totalCalories.toDouble(),
                    color: color,
                    width: 12,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  String _formatPeriodLabel(String period, PeriodType groupBy) {
    if (groupBy == PeriodType.day) {
      try {
        final date = DateFormat('dd/MM/yyyy HH:mm:ss').parse(period);
        return DateFormat('dd/MM').format(date);
      } catch (e) {
        return period;
      }
    } else if (groupBy == PeriodType.day) {
      try {
        final parts = period.split('-');
        if (parts.length == 2) {
          final year = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          if (year != null && month != null) {
            return month.toString();
          }
        }
        return period;
      } catch (e) {
        return period;
      }
    }
    return period;
  }
}