import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../screens/features/goal/calories_goal_screen.dart';
import '../../../screens/features/meal/bloc/meal_bloc.dart';
import '../../../screens/features/meal/bloc/meal_event.dart';

class KcalMealScreenWidget extends StatelessWidget {
  final double kcal;
  final double goal;
  final DateTime selectedDate;

  const KcalMealScreenWidget({
    super.key,
    required this.kcal,
    required this.goal,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
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
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/goal.svg",
                      height: 26,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      kcal.toInt().toString(),
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '/',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Text(
                      goal.toInt().toString(),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),

                const SizedBox(height: 8.0),

                Text(
                  "Ваша ціль",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 64),
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalorieGoalScreen()),
              ).then((_) {
                final date = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

                context.read<MealBloc>().add(
                  GetUserKcalToday(date: date),
                );
              });

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

          const SizedBox(width: 16),
        ],
      ),

    );
  }
}