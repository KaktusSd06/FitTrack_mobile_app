import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/models/gym_model.dart';
import '../../logic/bloc/user_update/user_update_bloc.dart';
import '../../logic/bloc/user_update/user_update_event.dart';
import '../../logic/bloc/user_update/user_update_state.dart';
import '../dialogs/confirmation_dialog.dart';

class GymInfoWidget extends StatelessWidget {
  final GymModel gym;
  final ConfirmationDialog confirmationDialog = ConfirmationDialog();

  GymInfoWidget({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserUpdateBloc, UserUpdateState>(
      listener: (context, state) {
        if (state is UserUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Зал успішно вибрано',
                style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).primaryColor,
              margin: const EdgeInsets.all(16),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        } else if (state is UserUpdateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Не вдалось вибрати зал'),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: GestureDetector(
          onTap: () => _handleGymSelection(context),
          child: Container(
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
                                  "Загальна оцінка:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(fontWeight: FontWeight.w500)
                              ),
                              const SizedBox(width: 12),
                              Text(
                                  gym.rating.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(fontWeight: FontWeight.w500)
                              ),
                              const SizedBox(width: 2),
                              const Icon(Icons.star, size: 20, color: Colors.yellow)
                            ],
                          ),
                          const SizedBox(height: 4,),
                          Text(
                              "${gym.address.city}, ${gym.address.street}, ${gym.address.building}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w300,
                                color: Theme.of(context).brightness == Brightness.light ? const Color(0xFF8C8C8C) : Theme.of(context).hintColor,
                              )
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(26)
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        "assets/icons/change_icon.svg",
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

  Future<void> _handleGymSelection(BuildContext context) async {
    final bool confirmed = await confirmationDialog.showConfirmationDialog(
        context,
        'Зміна спортзалу',
        'Ви дійсно бажаєте змінити свій спортзал на "${gym.name}"?'
    );

    if (confirmed) {
      if (context.mounted) {
        final userUpdateBloc = context.read<UserUpdateBloc>();
        userUpdateBloc.add(UpdateUserGymEvent(gym.id));
      }
    }
  }
}