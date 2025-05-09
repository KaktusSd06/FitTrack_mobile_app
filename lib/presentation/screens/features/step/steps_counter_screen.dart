import 'package:fittrack/presentation/screens/features/step/step_statistics_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../goal/step_goal_screen.dart';
import 'bloc/step_bloc.dart';
import 'bloc/step_event.dart';

import 'bloc/step_state.dart' as app_step_state;

class StepCounterScreen extends StatefulWidget {
  const StepCounterScreen({super.key});

  @override
  State<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  @override
  void initState() {
    super.initState();
    _loadStepData();
  }

  void _loadStepData() {
    final today = DateTime.now();
    context.read<StepBloc>().add(FetchDailySteps(date: today));
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
              icon: SvgPicture.asset(
                "assets/icons/statistic_icon.svg",
                height: 20,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StepStatisticsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<StepBloc, app_step_state.StepState>(
        builder: (context, state) {
          if (state is app_step_state.StepLoading || state is app_step_state.StepInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is app_step_state.StepError) {
            return Center(
              child: SvgPicture.asset(
                "assets/images/error.svg",
                width: 152,
                height: 152,
              ),
            );
          } else if (state is app_step_state.StepLoaded) {
            return _buildStepCounter(context, state);
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

  Widget _buildStepCounter(BuildContext context, app_step_state.StepLoaded state) {
    final progressPercentage = state.dailySteps / state.goalSteps;
    final cappedProgress = progressPercentage > 1.0 ? 1.0 : progressPercentage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Step count
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${state.dailySteps}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'кроків',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Progress bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: cappedProgress,
                          backgroundColor: Colors.grey.shade300,
                          color: Theme.of(context).primaryColor,
                          minHeight: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Stats (distance and calories)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${state.distance.toStringAsFixed(2)} км',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${state.calories} ккал',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
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

            const SizedBox(height: 22),
            // Goal section
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Ваша ціль: ',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${state.goalSteps}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,

                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const StepGoalScreen(),
                            ),
                          ).then((_) {
                            _loadStepData();
                          });
                        },
                        child: Text(
                          'Змінити ціль',
                          style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}