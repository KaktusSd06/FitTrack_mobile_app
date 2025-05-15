import 'package:fittrack/data/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageWidget extends StatelessWidget {
  final MessageModel message;

  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black.withAlpha((0.1 * 255).round())
                : Colors.white.withAlpha((0.1 * 255).round()),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${message.trainerLastname} ${message.trainerFirstname}",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).hintColor),
                ),
                Text(DateFormat('dd.MM.yyyy').format(DateTime.parse("${message.createdAt}")),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).hintColor),),
              ],
            ),
            const SizedBox(height: 4),
            Text(message.message,
              style: Theme.of(context).textTheme.displaySmall),
          ],
        ),
      ),
    );
  }
}