import 'package:fittrack/data/services/gym_feedback_service.dart';
import 'package:fittrack/data/services/gym_service.dart';
import 'package:fittrack/presentation/screens/features/gym_info/bloc/gym_info_bloc.dart';
import 'package:fittrack/presentation/screens/features/gym_info/bloc/gym_info_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/features/club/widget_with_title.dart';
import '../../../widgets/feedback_widget.dart';
import '../../../widgets/gym_info_widget.dart';
import '../store/store_screen.dart';
import 'bloc/gym_info_state.dart';

class GymInfoScreen extends StatefulWidget {
  final String gymId;
  const GymInfoScreen({required this.gymId, super.key});

  @override
  GymInfoScreenState createState() => GymInfoScreenState();
}

class GymInfoScreenState extends State<GymInfoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GymInfoBloc(
            gymService: GymService(),
            gymFeedbackService: GymFeedbackService()
          )..add(GetGymById(gymId: widget.gymId)),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: _buildContent(context),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<GymInfoBloc, GymInfoState>(
      builder: (context, gymState) {
        if (gymState is GymInfoInitial || gymState is GymInfoLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (gymState is GymInfoError) {
          return Center(child: Text('Помилка: ${gymState.message}'));
        } else if (gymState is GymInfoLoaded) {
          return CustomScrollView(
            slivers: [
              _buildGymImageHeader(context, gymState),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GymInfoWidget(gym: gymState.gym),
                      const SizedBox(height: 16,),
                      WidgetWithTitle(title: "Магазин",
                        icon: "assets/icons/store.svg",
                        onTap: () {
                          Navigator.push(context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation,
                                  secondaryAnimation) => StoreScreen(gymId:  gymState.gym!.id),
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

                        },),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FeedbackWidget(feedbacks: gymState.gymFeedbacks, gymId: gymState.gym.id),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return const Center(
          child: Text("Здається у нас проблеми, спробуйте пізніше :("),
        );
      },
    );
  }

  Widget _buildGymImageHeader(BuildContext context, GymInfoLoaded state) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      expandedHeight: 180.0,
      pinned: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Theme.of(context).hintColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          state.gym.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            state.gym.mainImagePreSignedUrl != null
                ? Image.network(
              state.gym.mainImagePreSignedUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: const Center(
                  child: Icon(
                    Icons.fitness_center,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
            )
                : Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Center(
                child: Icon(
                  Icons.fitness_center,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                  stops: const [0.3, 1],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}