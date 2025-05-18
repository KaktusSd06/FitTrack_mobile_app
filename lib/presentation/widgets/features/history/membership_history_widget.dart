import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/store/user_membership_model.dart';

class MembershipHistoryWidget extends StatelessWidget {
  final UserMembershipModel membership;
  final Function()? onBuyPressed;

  const MembershipHistoryWidget({
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        membership.membership!.name,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      _buildStatusIndicator(context),
                    ],
                  ),

                ],
              ),
            ),

            SizedBox(height: 4,),

            Text(
              '${membership.gymTitle}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 4,),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (membership.membership!.durationMonth != null)
                  _buildDetailRow(
                    context: context,
                    icon: Icons.calendar_month,
                    label: _getDurationText(),
                  ),
                if (membership.membership!.allowedSessions != null)
                  _buildDetailRow(
                    context: context,
                    icon: Icons.confirmation_num,
                    label: _getSessionsText(),
                  ),
              ],
            ),

            SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.monetization_on_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${membership.membership!.price} грн',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Text(
                  DateFormat('dd.MM.yyyy').format(membership.purchaseDate),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    Color statusColor;

    switch (membership.status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.amber;
        break;
      case 'active':
        statusColor = Colors.green;
        break;
      case 'expired':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
      ],
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

  String _getDurationText() {
    final duration = membership.membership!.durationMonth;
    if (duration == null) return '';

    if (duration == 1) return 'Термін дії: 1 місяць';
    if (duration > 1 && duration < 5) return 'Термін дії: $duration місяці';
    return 'Термін дії: $duration місяців';
  }

  String _getSessionsText() {
    final sessions = membership.membership!.allowedSessions;
    if (sessions == null) return '';

    return 'Кількість тренувань: $sessions';
  }
}