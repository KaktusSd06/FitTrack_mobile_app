import 'package:fittrack/presentation/screens/features/club/bloc/club_event.dart';
import 'package:fittrack/presentation/screens/features/club/bloc/club_state.dart';
import 'package:fittrack/presentation/screens/features/group_trainings/group_training_screen.dart';
import 'package:fittrack/presentation/screens/features/gym/gym_list_screen.dart';
import 'package:fittrack/presentation/widgets/features/club/widget_with_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../dialogs/error_dialog.dart';
import '../../../widgets/features/club/widget_with_title_and_text.dart';
import '../store/store_screen.dart';
import '../trainers/trainers_list_screen.dart';
import 'bloc/club_bloc.dart';

class ClubScreen extends StatefulWidget{
  const ClubScreen({super.key});

  @override
  State<ClubScreen> createState() => ClubScreenState();
}

class ClubScreenState extends State<ClubScreen> {

  @override
  void initState() {
    super.initState();
    _loadPageInfo();
  }

  void _loadPageInfo() {
    context.read<ClubBloc>().add(const GetClubInfo());
  }

  void selectTrainer(String gymId){
    Navigator.push(context,
      PageRouteBuilder(
        pageBuilder: (context, animation,
            secondaryAnimation) => TrainersListScreen(gymId: gymId),
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
    ).then((_) {
      _loadPageInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
        child: BlocConsumer<ClubBloc, ClubState>(
            listener: (context, state) {
              if (state is ClubError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ErrorDialog().showErrorDialog(
                    context,
                    "Упс, помилка :(",
                    "Здається нам не вдалось завантажити дані, спробуйте ще раз",
                  );
                });
              }
            },

            builder: (context, state) {
              if (state is ClubLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              else if (state is ClubLoaded && state.gym != null) {
                return Column(
                  children: [
                    WidgetWithTitleAndText(
                      title: state.gym!.name,
                      text: "${state.gym!.address
                          .street} ${state.gym!.address.building}",
                      imgPath: null,
                      icon: "assets/icons/gym_icon.svg",
                      isBtnIcon: true,
                      onTap: () {
                        Navigator.push(context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation,
                                secondaryAnimation) => const GymListScreen(),
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
                        ).then((_) {
                          _loadPageInfo();
                        });
                      },
                    ),
                    if (state.membership != null) ...[
                      const SizedBox(height: 16),
                      WidgetWithTitleAndText(
                        title: state.membership!.membership!.name,
                        text: state.membership!.membership!.allowedSessions != null ?
                        "Всього відвідувань: ${state.membership!.membership!.allowedSessions.toString()}" :
                        "Тривалість: ${state.membership!.membership!.durationMonth.toString()} місяців",
                        imgPath: null,
                        icon: "assets/icons/membership.svg",
                        isBtnIcon: false,
                        onTap: () {},
                      ),
                    ],



                    const SizedBox(height: 16,),
                    state.trainer != null ?

                      WidgetWithTitleAndText(
                        title: state.trainer != null ? state.trainer!.lastName : "Оберіть тренера",
                        text: state.trainer != null ? state.trainer!.firstName : "",
                        imgPath: state.trainer!.profileImageUrl,
                        icon: null,
                        isBtnIcon: true,
                        onTap: () {
                          selectTrainer(state.gym!.id);
                        },
                      )
                    :
                    WidgetWithTitle(title: "Оберіть тренера",
                      icon: "assets/icons/account.svg",
                      onTap: () {
                        selectTrainer(state.gym!.id);
                      },),
                    const SizedBox(height: 16,),
                    WidgetWithTitle(title: "Групові тренування",
                      icon: "assets/icons/group_trainings.svg",
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => GroupTrainingScreen(gymId: state.gym!.id)));
                      },),
                    const SizedBox(height: 16,),
                    WidgetWithTitle(title: "Магазин",
                      icon: "assets/icons/store.svg",
                      onTap: () {
                        Navigator.push(context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation,
                                secondaryAnimation) => StoreScreen(gymId:  state.gym!.id),
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
                        ).then((_) {
                          _loadPageInfo();
                        });

                      },),
                  ],
                );
              }
              else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/club_screen_empty.svg",
                            height: 259.84,
                          ),
                          const SizedBox(height: 16,),
                          Text(
                            "Оберіть зал з переліку доступних, аби використовувати більше функцій",
                            style: Theme
                                .of(context)
                                .textTheme
                                .displaySmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16,),
                          SizedBox(
                            width: double.infinity,
                            height: 40.0,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) => const GymListScreen(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      final tween = Tween(
                                          begin: const Offset(1, 0.0),
                                          end: Offset.zero);
                                      final curvedAnimation = CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOut,
                                      );

                                      return SlideTransition(
                                        position: tween.animate(
                                            curvedAnimation),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              }, style: ElevatedButton.styleFrom(
                              backgroundColor: Theme
                                  .of(context)
                                  .primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              disabledBackgroundColor: Theme
                                  .of(context)
                                  .disabledColor,
                            ),
                              child: Text(
                                'Обрати зал',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme
                                      .of(context)
                                      .scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                );
              }
            }
        ),
      ),
    );
  }
}
