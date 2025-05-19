import 'package:fittrack/data/models/store/purchases_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceHistoryWidget extends StatelessWidget {
  final PurchaseModel service;

  const ServiceHistoryWidget({
    required this.service,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme
            .of(context)
            .cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme
                .of(context)
                .brightness == Brightness.light
                ? Colors.black.withAlpha((0.1 * 255).round())
                : Colors.white.withAlpha((0.1 * 255).round()),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .primaryColor
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getServiceIcon(),
                  size: 16,
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.product!.name,
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      service.product!.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        color: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.7),
                      ),
                    ),

                    const SizedBox(height: 8),

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
                                '${service.price} грн',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Text(
                            DateFormat('dd.MM.yyyy').format(service.purchaseDate),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]
                    )

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getServiceIcon() {
    final String serviceName = service.product!.name.toLowerCase();

    if (serviceName.contains('тренування')) {
      return Icons.fitness_center;
    } else if (serviceName.contains('масаж')) {
      return Icons.spa;
    } else if (serviceName.contains('нутриц') || serviceName.contains('харчування')) {
      return Icons.restaurant_menu;
    } else if (serviceName.contains('консультац')) {
      return Icons.question_answer;
    } else {
      return Icons.sports;
    }
  }
}