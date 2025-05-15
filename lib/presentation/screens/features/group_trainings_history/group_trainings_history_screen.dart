import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../widgets/group_training_history_widgets.dart';
import 'bloc/group_trainings_history_bloc.dart';
import 'bloc/group_trainings_history_event.dart';
import 'bloc/group_trainings_history_state.dart';


class GroupTrainingsHistoryScreen extends StatefulWidget {
  const GroupTrainingsHistoryScreen({super.key});

  @override
  GroupTrainingsHistoryScreenState createState() => GroupTrainingsHistoryScreenState();
}

class GroupTrainingsHistoryScreenState extends State<GroupTrainingsHistoryScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadGroupTrainingsHistory();
  }

  void _loadGroupTrainingsHistory() {
    context.read<GroupTrainingsHistoryBloc>().add(const GetGroupTrainingsByUser());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        title: Text(
            "Історія записів",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Theme
                .of(context)
                .hintColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Expanded(
        child: BlocBuilder<GroupTrainingsHistoryBloc,
            GroupTrainingHistoryState>(
          builder: (context, state) {
            if (state is GroupTrainingHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GroupTrainingHistoryLoaded) {
              final trainings = state.groupTrainings;

              if (trainings.isEmpty) {
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/club_screen_empty.svg",
                          height: 259.84,
                        ),
                        const SizedBox(height: 16,),
                        Text(
                          "Саме час записатись на тренування",
                          style: Theme
                              .of(context)
                              .textTheme
                              .displaySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: trainings.length,
                itemBuilder: (context, index) {
                  return GroupTrainingHistoryWidgets(
                      training: trainings[index]);
                },
              );
            } else if (state is GroupTrainingHistoryError) {
              Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/club_screen_empty.svg",
                        height: 259.84,
                      ),
                      const SizedBox(height: 16,),
                      Text(
                        "Виникла помилка завантаження тренувань, спробуйте пізніше",
                        style: Theme
                            .of(context)
                            .textTheme
                            .displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
              );
            }

            return const Center(
              child: Text('Виберіть дату для перегляду тренувань'),
            );
          },
        ),
      ),
    );
  }
}