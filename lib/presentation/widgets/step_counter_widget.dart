import 'package:fittrack/presentation/screens/features/step/steps_counter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/features/step/bloc/step_bloc.dart';
import '../screens/features/step/bloc/step_state.dart' as app_step;

class StepCounterWidget extends StatelessWidget {
  const StepCounterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using the same StepBloc as the main page
    return BlocBuilder<StepBloc, app_step.StepState>(
      builder: (context, state) {
        if (state is app_step.StepLoading) {
          return _buildLoadingWidget();
        } else if (state is app_step.StepError) {
          return _buildErrorWidget(state.message);
        } else if (state is app_step.StepLoaded) {
          // Use the same data from the existing state
          return _buildStepCounterWidget(
            context,
            state.dailySteps,
            state.goalSteps,
          );
        }

        // Default state when no data is available
        return _buildEmptyWidget();
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        'Помилка: $message',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Text('Немає даних'),
    );
  }

  Widget _buildStepCounterWidget(BuildContext context, int currentSteps, int goalSteps) {
    final double progressPercentage = currentSteps / goalSteps;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => StepCounterScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(

          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentSteps.toString(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '/$goalSteps кроки',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2.0, right: 16, left: 1),
                child: Stack(
                  children: [
                    Container(
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progressPercentage.clamp(0.0, 1.0),
                      child: Container(
                        height: 15,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
