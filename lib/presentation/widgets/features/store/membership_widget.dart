import 'package:fittrack/data/models/store/membership_model.dart';
import 'package:flutter/material.dart';

class MembershipWidget extends StatelessWidget {
  final MembershipModel membership;
  final Function()? onBuyPressed;

  const MembershipWidget({
    required this.membership,
    this.onBuyPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        membership.name,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.monetization_on_outlined,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${membership.price} грн',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (membership.durationMonth != null)
                  _buildDetailRow(
                    context: context,
                    icon: Icons.calendar_month,
                    label: _getDurationText(),
                  ),
                if (membership.allowedSessions != null)
                  _buildDetailRow(
                    context: context,
                    icon: Icons.confirmation_num,
                    label: _getSessionsText(),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onBuyPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Придбати',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  String _getMembershipTypeLabel() {
    switch (membership.type) {
      case 'SessionLimited':
        return 'Абонемент з обмеженням за кількістю тренувань';
      case 'TimeLimited':
        return 'Абонемент з обмеженням за часом';
      case 'Combined':
        return 'Комбінований абонемент';
      default:
        return membership.type;
    }
  }

  String _getDurationText() {
    final duration = membership.durationMonth;
    if (duration == null) return '';

    if (duration == 1) return 'Термін дії: 1 місяць';
    if (duration > 1 && duration < 5) return 'Термін дії: $duration місяці';
    return 'Термін дії: $duration місяців';
  }

  String _getSessionsText() {
    final sessions = membership.allowedSessions;
    if (sessions == null) return '';

    return 'Кількість тренувань: $sessions';
  }
}