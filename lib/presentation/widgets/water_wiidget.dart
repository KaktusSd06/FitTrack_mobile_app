import 'package:fittrack/presentation/screens/features/goal/water_goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../screens/features/page_with_indicators/bloc/page_with_indicators_bloc.dart';
import '../screens/features/page_with_indicators/bloc/page_with_indicators_event.dart';
import '../screens/features/water_info/add_water_info_screen.dart';

class WaterWidget extends StatelessWidget {
  final double waterMl;
  final double goal;

  const WaterWidget({
    super.key,
    required this.waterMl,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const WaterGoalScreen())).then((_) {
          context.read<PageWithIndicatorsBloc>().add(
            GetUserKcalSumToday(
              date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
            ),
          );
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
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
                      const Icon(Icons.water_drop, color: Colors.blue, size: 26),
                      const SizedBox(width: 8),
                      Text(
                        waterMl.toInt().toString(),
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
                      Text(
                        ' мл',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8.0),

                  Text(
                    "Сьогодні випито",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 64),
            GestureDetector(
              onTap: () {

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddWaterInfoScreen(currentWater: waterMl,))).then((_) {
                  context.read<PageWithIndicatorsBloc>().add(
                    GetUserKcalSumToday(
                      date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                    ),
                  );
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    "assets/icons/add_icon.svg",
                    width: 14,
                    height: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),
          ],
        ),

      ),
    );
  }
}