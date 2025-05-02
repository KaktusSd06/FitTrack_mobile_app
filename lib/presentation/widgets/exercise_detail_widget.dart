import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ExerciseDetailWidget extends StatelessWidget {
  final String exerciseName;
  final String description;

  const ExerciseDetailWidget({
    super.key,
    required this.exerciseName,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exerciseName,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8.0),
                Text(
                  description,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 64),
          SvgPicture.asset(
            "assets/icons/add_icon_circular.svg",
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 16),
        ],
      ),

    );
  }
}