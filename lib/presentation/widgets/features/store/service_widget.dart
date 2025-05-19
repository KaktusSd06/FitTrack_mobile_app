import 'package:fittrack/data/models/store/service_model.dart';
import 'package:flutter/material.dart';

class ServiceWidget extends StatelessWidget {
  final ServiceModel service;
  final Function()? onBookPressed;

  const ServiceWidget({
    required this.service,
    this.onBookPressed,
    Key? key,
  }) : super(key: key);

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
        onTap: () {
          _showServiceDetails(context);
        },
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
                    // Service name
                    Text(
                      service.name,
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Service description
                    Text(
                      service.description,
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

                    // Service price
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

                          ElevatedButton(
                            onPressed: onBookPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme
                                  .of(context)
                                  .primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Придбати',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ]
                    )

                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Book button

            ],
          ),
        ),
      ),
    );
  }

  IconData _getServiceIcon() {
    final String serviceName = service.name.toLowerCase();

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

  void _showServiceDetails(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with drag indicator
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Service icon and name
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getServiceIcon(),
                          size: 28,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          service.name,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Price section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.monetization_on_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Вартість: ${service.price} грн',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description section
                  Text(
                    'Опис',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 32),

                  // Book button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (onBookPressed != null) {
                          onBookPressed!();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Придбати',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
