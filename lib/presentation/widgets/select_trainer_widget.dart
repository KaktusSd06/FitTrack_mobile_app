import 'package:fittrack/data/models/trainer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../logic/bloc/user_update/user_update_bloc.dart';
import '../../logic/bloc/user_update/user_update_event.dart';
import '../../logic/bloc/user_update/user_update_state.dart';
import '../dialogs/confirmation_dialog.dart';

class SelectTrainerWidget extends StatelessWidget {
  final ConfirmationDialog confirmationDialog = ConfirmationDialog();
  final TrainerModel trainer;

  SelectTrainerWidget({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserUpdateBloc, UserUpdateState>(
        listener: (context, state) {
          if (state is UserUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Тренера змінено',
                  style: TextStyle(color: Theme
                      .of(context)
                      .scaffoldBackgroundColor),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme
                    .of(context)
                    .primaryColor,
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
                content: const Text('Не вдалось вибрати тренера'),
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
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(trainer.profileImageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                trainer.lastName,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(fontWeight: FontWeight.w500)
                            ),
                            Text(trainer.firstName, style: Theme
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
                          borderRadius: const BorderRadius.all(
                              Radius.circular(26))
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
        )
    );
  }

  Future<void> _handleGymSelection(BuildContext context) async {
    final bool confirmed = await confirmationDialog.showConfirmationDialog(
        context,
        'Зміна тренера',
        'Ви дійсно бажаєте обрати тренера "${trainer.lastName} ${trainer.firstName}"?'
    );

    if (confirmed) {
      if (context.mounted) {
        final userUpdateBloc = context.read<UserUpdateBloc>();
        userUpdateBloc.add(UpdateUserTrainerEvent(trainer.id));
      }
    }
  }
}