import 'package:fittrack/data/models/set_model.dart';
import 'package:fittrack/presentation/screens/features/exercise/select_exercise_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../dialogs/confirmation_dialog.dart';
import '../set/bloc/set_bloc.dart';
import '../set/bloc/set_event.dart';
import '../set/bloc/set_state.dart';
import 'dart:async';
import '../set/create_set_screen.dart';
import 'bloc/individual_training_bloc.dart';
import 'bloc/individual_training_event.dart';
import 'bloc/individual_training_state.dart';

class IndividualTrainingScreen extends StatefulWidget {
  const IndividualTrainingScreen({super.key});

  @override
  IndividualTrainingScreenState createState() => IndividualTrainingScreenState();
}

class IndividualTrainingScreenState extends State<IndividualTrainingScreen> with AutomaticKeepAliveClientMixin {
  DateTime selectedDate = DateTime.now();
  DateTime startOfWeek = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;
  String _currentTrainingId = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getStartOfWeek(selectedDate);
    _scrollController.addListener(_toggleFabVisibility);

    _loadTrainingsForDate();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_toggleFabVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleFabVisibility() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse && _isFabVisible) {
      setState(() {
        _isFabVisible = false;
      });
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward && !_isFabVisible) {
      setState(() {
        _isFabVisible = true;
      });
    }
  }

  void getStartOfWeek(DateTime date) {
    startOfWeek = date.subtract(Duration(days: date.weekday - 1));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        getStartOfWeek(selectedDate);
      });
      _loadTrainingsForDate();
    }
  }

  void _selectDateDay(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    _loadTrainingsForDate();
  }

  void _loadTrainingsForDate() {
    final fromDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final toDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

    context.read<IndividualTrainingBloc>().add(
      GetIndividualTrainingsByPeriod(
        fromDate: fromDate,
        toDate: toDate,
      ),
    );
  }

  void _deleteSet(String setId) {
    final confirmationDialog = ConfirmationDialog();
    confirmationDialog
        .showConfirmationDialog(
        context,
        "Підтвердження видалення",
        "Ви впевнені, що хочете видалити сет?"
    ).then((confirmed) {
      if (confirmed) {
        final setBloc = context.read<SetBloc>();
        late final StreamSubscription subscription;
        subscription = setBloc.stream.listen((state) {
          if (state is SetDeleted && state.setId == setId) {
            subscription.cancel();
            _loadTrainingsForDate();
          } else if (state is SetFailure) {
            subscription.cancel();
          }
        });

        setBloc.add(DeleteSet(setId));
      }
    });
  }

  void _goToPreviousWeek() {
    setState(() {
      startOfWeek = startOfWeek.subtract(const Duration(days: 7));
      selectedDate = startOfWeek;
    });
    _loadTrainingsForDate();
  }

  void _goToNextWeek() {
    setState(() {
      startOfWeek = startOfWeek.add(const Duration(days: 7));
      selectedDate = startOfWeek;
    });
    _loadTrainingsForDate();
  }

  String getMonthName(int month) {
    switch (month) {
      case 1: return 'Січень';
      case 2: return 'Лютий';
      case 3: return 'Березень';
      case 4: return 'Квітень';
      case 5: return 'Травень';
      case 6: return 'Червень';
      case 7: return 'Липень';
      case 8: return 'Серпень';
      case 9: return 'Вересень';
      case 10: return 'Жовтень';
      case 11: return 'Листопад';
      case 12: return 'Грудень';
      default: return '';
    }
  }

  String getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'ПН';
      case 2: return 'ВТ';
      case 3: return 'СР';
      case 4: return 'ЧТ';
      case 5: return 'ПТ';
      case 6: return 'СБ';
      case 7: return 'НД';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
            "FitTrack",
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Theme.of(context).primaryColor
            )
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _goToPreviousWeek,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Icon(
                          CupertinoIcons.chevron_back,
                          color: Theme.of(context).brightness == Brightness.light ? const Color(0xFF8C8C8C) : Theme.of(context).hintColor,
                          size: 24.0,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.calendar_today,
                              color: Theme.of(context).brightness == Brightness.light ? const Color(0xFF8C8C8C) : Theme.of(context).hintColor,
                              size: 24.0,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              '${getMonthName(selectedDate.month)} ${selectedDate.year}',
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.light ? const Color(0xFF8C8C8C) : Theme.of(context).hintColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _goToNextWeek,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Icon(
                          CupertinoIcons.chevron_forward,
                          color: Theme.of(context).brightness == Brightness.light ? const Color(0xFF8C8C8C) : Theme.of(context).hintColor,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      DateTime currentDate = startOfWeek.add(Duration(days: index));
                      bool isSelected = currentDate.day == selectedDate.day &&
                          currentDate.month == selectedDate.month &&
                          currentDate.year == selectedDate.year;

                      return GestureDetector(
                        onTap: () => _selectDateDay(currentDate),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          width: isSelected
                              ? 60.0
                              : 40.0,
                          height: 60.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getDayName(currentDate.weekday),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context).hintColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '${currentDate.day}',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context).brightness == Brightness.light ? const Color(0xFF8C8C8C) : Theme.of(context).hintColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<IndividualTrainingBloc, IndividualTrainingState>(
              builder: (context, state) {
                if (state is IndividualTrainingLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is IndividualTrainingLoaded) {
                  final training = state.trainings;
                  _currentTrainingId =  training.id;

                  if (training.sets.isEmpty) {
                    return Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 100),
                            SvgPicture.asset(
                              "assets/images/trainings_empty.svg",
                              width: 177.31,
                              height: 277.4,
                            ),
                            const SizedBox(height:8),
                            Text(
                              "Розпочніть тренування вже зараз",
                              style: Theme.of(context).textTheme.displaySmall,
                            )
                          ],
                        )
                    );
                  }

                  final Map<String, List<SetModel>> groupedSets = {};
                  for (var set in training.sets) {
                    final exerciseName = set.exercise?.name ?? 'Без назви';
                    if (!groupedSets.containsKey(exerciseName)) {
                      groupedSets[exerciseName] = [];
                    }
                    groupedSets[exerciseName]!.add(set);
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: groupedSets.length,
                    itemBuilder: (context, index) {
                      final exerciseName = groupedSets.keys.elementAt(index);
                      final sets = groupedSets[exerciseName]!;

                      return Card(
                        color: Theme.of(context).cardColor,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    exerciseName,
                                    style: Theme.of(context).textTheme.displaySmall,
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(right: 18),
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CreateSetScreen(
                                              exerciseId: sets.first.exercise!.id.toString(),
                                              individualTrainingId: _currentTrainingId,
                                              selectedDate: selectedDate,
                                            ),
                                          ),
                                        ).then((_) {
                                          _loadTrainingsForDate();
                                        });
                                      },
                                      child: SvgPicture.asset(
                                      "assets/icons/add_icon_circular.svg",
                                      width: 19.0,
                                      height: 19.0,
                                    ),
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(height: 8,),

                              ...sets.map((set) => _buildSetItem(set, context)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is IndividualTrainingError) {
                  _currentTrainingId = '';
                  return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 100),
                          SvgPicture.asset(
                            "assets/images/trainings_empty.svg",
                            width: 177.31,
                            height: 277.4,
                          ),
                          const SizedBox(height:8),
                          Text(
                            "Розпочніть тренування вже зараз",
                            style: Theme.of(context).textTheme.displaySmall,
                          )
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
        ],
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _isFabVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 400),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>  SelectExerciseScreen(
                  individualTrainingId: _currentTrainingId,
                  selectedDate: selectedDate,
                ),
              ),
            ).then((_) {
              _loadTrainingsForDate();
            });
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add, color: Theme.of(context).scaffoldBackgroundColor,),
        ),
      ),
    );
  }

  Widget _buildSetItem(SetModel set, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).hintColor,
              width: 1,
            ),
          )
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  'Повторів: ',
                  style: Theme.of(context).textTheme.headlineMedium
                ),
                Text(
                  '${set.reps}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Expanded(
            child: Row(
              children: [
                Text(
                  'Вага: ',
                    style: Theme.of(context).textTheme.headlineMedium

                ),
                Text(
                  '${set.weight} кг',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          IconButton(
            icon: Icon(
              Icons.close,
              size: 18,
              color: Colors.grey[600],
            ),
            onPressed: () {
              _deleteSet(set.id!);
            },
          ),
        ],
      ),
    );
  }
}