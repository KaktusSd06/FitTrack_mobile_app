import 'package:fittrack/presentation/screens/features/meal/meal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../screens/features/page_with_indicators/bloc/page_with_indicators_bloc.dart';
import '../../../screens/features/page_with_indicators/bloc/page_with_indicators_event.dart';

class KcalHomeScreenWidget extends StatelessWidget {
  final double kcal;
  final double goal;

  const KcalHomeScreenWidget({
    super.key,
    required this.kcal,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MealScreen())).then((_) {
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
                      SvgPicture.asset(
                        "assets/icons/kcal_icon.svg",
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
                    "Сьогодні спожито",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 64),
            GestureDetector(
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