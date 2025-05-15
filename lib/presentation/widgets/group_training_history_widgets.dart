import 'package:fittrack/data/models/group_training.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


class GroupTrainingHistoryWidgets extends StatelessWidget {
  final GroupTraining training;

  const GroupTrainingHistoryWidgets({super.key, required this.training});

  void _callTrainer(BuildContext context, String phoneNumber) async {
    String cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (cleanedPhoneNumber.startsWith('380')) {
      cleanedPhoneNumber = '+$cleanedPhoneNumber';
    } else if (!cleanedPhoneNumber.startsWith('+')) {
      cleanedPhoneNumber = '+380$cleanedPhoneNumber';
    }

    final Uri launchUri = Uri(
        scheme: 'tel',
        path: cleanedPhoneNumber
    );

    try {
      final bool launched = await launchUrl(
          launchUri,
          mode: LaunchMode.externalApplication
      );

      if (!launched) {
        _showErrorSnackBar(context, 'Не вдалося здійснити дзвінок');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Сталась помилка, спробуйте пізніше');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black.withAlpha((0.1 * 255).round())
                : Colors.white.withAlpha((0.1 * 255).round()),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Time column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat.Hm().format(training.dateTime),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${training.durationInMinutes.toString()} хв",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).brightness == Brightness.light
                            ? const Color(0xFF8C8C8C)
                            : Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 36),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        training.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${training.trainerSurname} ${training.trainerName}",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).brightness == Brightness.light
                              ? const Color(0xFF8C8C8C)
                              : Theme.of(context).hintColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('dd.MM.yyyy').format(training.dateTime),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).brightness == Brightness.light
                              ? const Color(0xFF8C8C8C)
                              : Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _callTrainer(context, training.contactPhone),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Icon(
                CupertinoIcons.phone,
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 24.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}