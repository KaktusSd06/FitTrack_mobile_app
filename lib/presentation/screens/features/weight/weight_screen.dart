import 'package:fittrack/presentation/screens/features/weight/weight_char_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/svg.dart';
import 'add_weight_screen.dart';
import 'bloc/weight_bloc.dart';
import 'bloc/weight_event.dart';
import 'bloc/weight_state.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 14));

    context.read<WeightBloc>().add(LoadWeights(from: startDate, to: now));
    context.read<WeightBloc>().add(LoadLatestWeight());
    context.read<WeightBloc>().add(LoadMonthlyChange());
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
            child: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).hintColor
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Вага',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart, color: Theme.of(context).hintColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<WeightBloc>(),
                    child: const WeightChartScreen(),
                  ),
                ),
              ).then((_) => _loadData());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildWeightChart(),
                const SizedBox(height: 20),
                _buildWeightInfo(),
                const SizedBox(height: 20),
                _buildLatestRecord(),
                const SizedBox(height: 20),
                _buildAddRecordButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeightChart() {
    return BlocBuilder<WeightBloc, WeightState>(
      buildWhen: (previous, current) => current is WeightsLoaded || current is WeightLoading,
      builder: (context, state) {
        if (state is WeightLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is WeightsLoaded) {
          final weights = state.weights;
          if (weights.isEmpty) {
            return Center(
              child: SvgPicture.asset(
                "assets/images/weight.svg",
                height: 300,
              ),
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
            height: 200,
            padding: const EdgeInsets.only(top: 20),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(
                  show: false,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value % 2 == 0 && value < weights.length) {
                          return Text(
                            '${weights[value.toInt()].date.day}/${weights[value.toInt()].date.month}',
                            style:  TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 10,
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 22,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                minX: 0,
                maxX: (weights.length - 1).toDouble(),
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false,
                    color: Theme.of(context).primaryColor,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Theme.of(context).primaryColor,
                          strokeWidth: 0,
                          strokeColor:Theme.of(context).primaryColor,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox(
          height: 200,
          child: Center(child: Text('Немає даних')),
        );
      },
    );
  }

  Widget _buildWeightInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Різниця в вазі:',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              BlocBuilder<WeightBloc, WeightState>(
                buildWhen: (previous, current) => current is MonthlyChangeLoaded,
                builder: (context, state) {
                  if (state is MonthlyChangeLoaded) {
                    final change = state.change;
                    if (change == null) {
                      return const Text(
                        '0 кг',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      );
                    }

                    final sign = change > 0 ? '+' : '';
                    return Text(
                      '$sign${change.toStringAsFixed(1)} кг',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    );
                  }
                  return const Text(
                    '...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  );
                },
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'За місяць:',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              BlocBuilder<WeightBloc, WeightState>(
                buildWhen: (previous, current) => current is MonthlyChangeLoaded,
                builder: (context, state) {
                  if (state is MonthlyChangeLoaded) {
                    final change = state.change;
                    if (change == null) {
                      return const Text(
                        '+0 кг',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      );
                    }

                    final sign = change > 0 ? '+' : '';
                    return Text(
                      '$sign${change.toStringAsFixed(1)} кг',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    );
                  }
                  return const Text(
                    '...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLatestRecord() {
    return BlocBuilder<WeightBloc, WeightState>(
      buildWhen: (previous, current) => current is LatestWeightLoaded,
      builder: (context, state) {
        if (state is LatestWeightLoaded) {
          final weight = state.weight;
          if (weight == null) {
            return const Center(child: Text(''));
          }

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Останній запис',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${weight.weightKg.toStringAsFixed(1).padLeft(4, '0')} кг',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildAddRecordButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: context.read<WeightBloc>(),
                child: const AddWeightScreen(),
              ),
            ),
          ).then((_) => _loadData());
        },
        child: Text(
          'Додати новий запис',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}