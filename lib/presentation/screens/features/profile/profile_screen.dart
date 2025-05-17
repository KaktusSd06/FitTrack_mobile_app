import 'package:fittrack/presentation/screens/features/group_trainings_history/group_trainings_history_screen.dart';
import 'package:fittrack/presentation/screens/features/terms_of_use/terms_of_use_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fittrack/presentation/dialogs/confirmation_dialog.dart';
import '../../../dialogs/error_dialog.dart';
import '../../../widgets/profile_action_bloc.dart';
import '../../../widgets/user_avatar.dart';
import '../purchases_history/purchases_history_screen.dart';
import '../sign_in/bloc/sign_in_bloc.dart';
import '../sign_in/bloc/sign_in_event.dart';
import '../sign_in/sign_in_screen.dart';
import 'bloc/profile_bloc.dart';
import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileBloc _profileBloc = ProfileBloc();
  ProfileState? _lastProfileState;

  @override
  void initState() {
    super.initState();
    _profileBloc.add(LoadProfile());

    _profileBloc.stream.listen((state) {
      if (state is ProfileLoaded) {
        setState(() {
          _lastProfileState = state;
        });
      }
    });
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  Future<void> _sendEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'stepanukdima524@gmail.com',
      queryParameters: {
        'subject': "Зворотній зв'язок",
      },
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        ErrorDialog().showErrorDialog(
          context,
          "Упс, помилка :(",
          "Спробуйте пізніше, або напишіть нам: stepanukdima524@gmai.com",
        );
      }
    } catch (e) {
      ErrorDialog().showErrorDialog(
        context,
        "Упс, помилка :(",
        "Спробуйте пізніше, або напишіть нам: stepanukdima524@gmai.com",
      );
    }
  }

  Widget _buildProfileContent(ProfileLoaded state) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 24, right: 16, left: 16),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                state.photoUrl != null
                    ? Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(state.photoUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                    : UserAvatar(fullName: state.displayName ?? "User"),
                const SizedBox(width: 24),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: (state.displayName != null &&
                            state.displayName!.split(' ').length > 1)
                            ? state.displayName!.split(' ')[1]
                            : 'Без імені',
                        style: Theme
                            .of(context)
                            .textTheme
                            .displayMedium,
                      ),
                      const TextSpan(text: '\n'),
                      TextSpan(
                        text: (state.displayName != null &&
                            state.displayName!.split(' ').isNotEmpty)
                            ? state.displayName!.split(' ')[0]
                            : '',
                        style: Theme
                            .of(context)
                            .textTheme
                            .displaySmall,
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            Container(
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
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: Column(
                    children: [
                      ActionBlock(
                        svgPath: "assets/icons/history.svg",
                        text: 'Історія покупок',
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PurchasesHistoryScreen()));
                        },
                      ),
                      ActionBlock(
                        svgPath: "assets/icons/record_history.svg",
                        text: 'Історія записів',
                        onTap: () {
                          Navigator.push(context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation,
                                  secondaryAnimation) => const GroupTrainingsHistoryScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                final tween = Tween(begin: const Offset(1, 0.0),
                                    end: Offset.zero);
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
                        isLastItem: true,
                      ),
                    ],
                  )
              ),
            ),
            const SizedBox(height: 12,),

            Container(
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
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: Column(
                    children: [
                      ActionBlock(
                        svgPath: "assets/icons/message.svg",
                        text: "Зв'язатись з нами",
                        onTap: () {
                          _sendEmail(context);
                        },
                        isLastItem: false,
                      ),
                      ActionBlock(
                        svgPath: "assets/icons/terms_of_use.svg",
                        text: 'Умови використання',
                        onTap: () {
                          Navigator.push(context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation,
                                  secondaryAnimation) => const TermsOfUseScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                final tween = Tween(begin: const Offset(1, 0.0),
                                    end: Offset.zero);
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

                      ),
                      ActionBlock(
                        svgPath: "assets/icons/exit.svg",
                        text: 'Вийти з застосунку',
                        onTap: () {
                          final confirmationDialog = ConfirmationDialog();
                          confirmationDialog
                              .showConfirmationDialog(
                              context,
                              "Підтвердження виходу",
                              "Ви впевнені, що хочете вийти з застосунку?"
                          ).then((confirmed) {
                            if (confirmed) {
                              context.read<SignInBloc>().add(
                                  SignOutEvent(context: context));
                            }
                          });
                        },
                      ),
                      ActionBlock(
                        svgPath: "assets/icons/delete.svg",
                        text: 'Видалити профіль',
                        onTap: () {
                          final confirmationDialog = ConfirmationDialog();
                          confirmationDialog
                              .showConfirmationDialog(
                            context,
                            "Підтвердження видалення",
                            "Ви впевнені, що бажаєте видалити профіль? Всі дані буде втрачено.",
                          )
                              .then((confirmed) {
                            if (confirmed) {
                              _profileBloc.add(DeleteAccount());
                            }
                          });
                        },
                        isLastItem: true,
                      ),
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .scaffoldBackgroundColor,
          title: Text(
              "FitTrack",
              style: Theme
                  .of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(
                  color: Theme
                      .of(context)
                      .primaryColor
              )
          ),
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is AccountDeleted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SignInScreen()),
                    (route) => false,
              );
            } else if (state is AccountDeletionError) {
              ErrorDialog().showErrorDialog(
                context,
                "Упс, помилка :(",
                state.message,
              );
            } else if (state is ProfileError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ErrorDialog().showErrorDialog(
                  context,
                  "Упс, помилка :(",
                  "Здається нам не вдалось вас знайти, спробуйте ще раз",
                );
              });
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading && _lastProfileState == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileLoaded || _lastProfileState is ProfileLoaded) {
              ProfileLoaded profileData = (state is ProfileLoaded)
                  ? state
                  : _lastProfileState as ProfileLoaded;

              return _buildProfileContent(profileData);
            }

            if (state is ProfileError && _lastProfileState == null) {
              return Center(
                child: SvgPicture.asset(
                  "assets/images/error.svg",
                  width: 152,
                  height: 152,
                ),
              );
            }

            if (_lastProfileState == null) {
              return const Center(child: CircularProgressIndicator());
            } else if (_lastProfileState is ProfileLoaded) {
              return _buildProfileContent(_lastProfileState as ProfileLoaded);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}