import 'package:fittrack/presentation/screens/features/sleep/sleep_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/sleep/sleep_entry_model.dart';
import '../screens/features/page_with_indicators/bloc/page_with_indicators_bloc.dart';
import '../screens/features/page_with_indicators/bloc/page_with_indicators_event.dart';

class SleepTimeWidget extends StatelessWidget {
  final SleepEntry sleepEntry;

  const SleepTimeWidget({
    super.key,
    required this.sleepEntry,
  });

  @override
  Widget build(BuildContext context) {
    final duration = sleepEntry.wakeUpTime.difference(sleepEntry.sleepStart);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    String formatTime(DateTime time) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }

    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SleepInfoScreen())).then((_) {
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
                      Icon(
                        Icons.nightlight_round,
                        color: Theme.of(context).primaryColor,
                        size: 26,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$hours год $minutes хв',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8.0),

                  Text(
                    "Тривалість сну сьогодні",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  "${formatTime(sleepEntry.sleepStart)} - ${formatTime(sleepEntry.wakeUpTime)}",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.normal,
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