import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/models/gym_model.dart';
import '../screens/features/gym_info/gym_info_screen.dart';

class SelectGymWidget extends StatelessWidget {
  final GymModel gym;

  const SelectGymWidget({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => GymInfoScreen(gymId: gym.id),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                final tween = Tween(begin: const Offset(1, 0.0), end: Offset.zero);
                final curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                );

                return SlideTransition(
                  position: tween.animate(curvedAnimation),
                  child: child,
                );
              },
            ),
          );

        },
        child: Container(
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
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                                gym.name,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(fontWeight: FontWeight.w500)
                            ),
                            const SizedBox(width: 14),
                            Text(
                                gym.rating.toString(),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(fontWeight: FontWeight.w500)
                            ),
                            Icon(Icons.star, size: 16, color: Theme.of(context).primaryColor)
                          ],
                        ),
                        Text(
                            "${gym.address.city}, ${gym.address.street}, ${gym.address.building}",
                            style: Theme
                            .of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w300))
                      ],
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(26))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      "assets/icons/keyboard_arrow_right.svg",
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}