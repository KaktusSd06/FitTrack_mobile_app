import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../data/models/weight_model.dart';
import 'bloc/weight_bloc.dart';
import 'bloc/weight_event.dart';
import 'bloc/weight_state.dart';


class WeightChartScreen extends StatefulWidget {
  const WeightChartScreen({super.key});

  @override
  State<WeightChartScreen> createState() => _WeightChartScreenState();
}

class _WeightChartScreenState extends State<WeightChartScreen> {
  String _selectedPeriod = '7 днів';
  final List<String> _periods = ['7 днів', '31 день', '12 міс.'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final now = DateTime.now();
    DateTime from;

    switch (_selectedPeriod) {
      case '7 днів':
        from = now.subtract(const Duration(days: 7));
        break;
      case '31 день':
        from = now.subtract(const Duration(days: 31));
        break;
      case '12 міс.':
        from = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        from = now.subtract(const Duration(days: 7));
    }

    context.read<WeightBloc>().add(LoadWeights(from: from, to: now));
    context.read<WeightBloc>().add(LoadLatestWeight());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Вага',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildPeriodSelector(),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildWeightChart(),
                    const SizedBox(height: 20),
                    _buildWeightStats(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _periods.map((period) {
          final isSelected = period == _selectedPeriod;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPeriod = period;
              });
              _loadData();
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    child: Text(
                      period,
                      style: TextStyle(
                        color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWeightChart() {
    return BlocBuilder<WeightBloc, WeightState>(
      buildWhen: (previous, current) => current is WeightsLoaded || current is WeightLoading,
      builder: (context, state) {
        if (state is WeightLoading) {
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is WeightsLoaded) {
          final weights = state.weights;
          if (weights.isEmpty) {
            return const SizedBox(
              height: 300,
              child: Center(child: Text('Немає даних для відображення')),
            );
          }

          weights.sort((a, b) => a.date.compareTo(b.date));

          double minY = weights.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b) - 1;
          double maxY = weights.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b) + 1;

          minY = (minY ~/ 1) * 1.0;
          maxY = ((maxY ~/ 1) + 1) * 1.0;

          List<FlSpot> spots = [];
          for (int i = 0; i < weights.length; i++) {
            spots.add(FlSpot(i.toDouble(), weights[i].weightKg));
          }

          return Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((0.21 * 255).round()),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withAlpha((0.21 * 255).round()),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= weights.length || value.toInt() < 0) {
                                return const SizedBox.shrink();
                              }

                              final date = weights[value.toInt()].date;

                              String text;
                              if (_selectedPeriod == '7 днів') {
                                text = '${date.day}.${date.month}';
                              } else if (_selectedPeriod == '31 день') {
                                if (value.toInt() % 5 == 0 || value.toInt() == weights.length - 1) {
                                  text = '${date.day}.${date.month}';
                                } else {
                                  return const SizedBox.shrink();
                                }
                              } else {
                                if (value.toInt() % ((weights.length ~/ 6).clamp(1, weights.length)) == 0 || value.toInt() == weights.length - 1) {
                                  text = '${date.month}/${date.year.toString().substring(2)}';
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }

                              return Text(
                                text,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toStringAsFixed(0),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              );
                            },
                            reservedSize: 40,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      minX: 0,
                      maxX: weights.length - 1.0,
                      minY: minY,
                      maxY: maxY,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [Theme.of(context).primaryColor, Colors.amber],
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: Colors.white,
                                strokeWidth: 2,
                                strokeColor: Theme.of(context).primaryColor,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.withAlpha((0.2 * 255).round()),
                                Colors.amber.withAlpha((0.05 * 255).round()),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox(
          height: 300,
          child: Center(child: Text('Дані відсутні')),
        );
      },
    );
  }

  Widget _buildWeightStats() {
    return BlocBuilder<WeightBloc, WeightState>(
      buildWhen: (previous, current) =>
      current is WeightsLoaded ||
          current is LatestWeightLoaded ||
          current is WeightLoading,
      builder: (context, state) {
        final latestWeight = state is LatestWeightLoaded ? state.weight : null;

        List<WeightModel> weights = [];
        if (state is WeightsLoaded) {
          weights = state.weights;
        } else if (state is LatestWeightLoaded && state.weights != null) {
          weights = state.weights!;
        }

        String changeText = 'Немає даних';
        Color changeColor = Colors.grey;
        double? changeValue;

        if (weights.length >= 2) {
          weights.sort((a, b) => a.date.compareTo(b.date));
          final firstWeight = weights.first.weightKg;
          final lastWeight = weights.last.weightKg;

          changeValue = lastWeight - firstWeight;

          if (changeValue > 0) {
            changeText = '+${changeValue.toStringAsFixed(1)} кг';
            changeColor = Colors.red;
          } else if (changeValue < 0) {
            changeText = '${changeValue.toStringAsFixed(1)} кг';
            changeColor = Colors.green;
          } else {
            changeText = 'Без змін';
            changeColor = Colors.grey;
          }
        }

        return Column(
          children: [
            if (latestWeight != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha((0.1 * 255).round()),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Зміна за $_selectedPeriod',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    changeText,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: changeColor,
                    ),
                  ),
                  if (weights.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem(
                          'Початкова',
                          '${weights.first.weightKg.toStringAsFixed(1)} кг',
                          _formatDate(weights.first.date),
                        ),
                        _buildStatItem(
                          'Кінцева',
                          '${weights.last.weightKg.toStringAsFixed(1)} кг',
                          _formatDate(weights.last.date),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String title, String value, String subtitle) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}