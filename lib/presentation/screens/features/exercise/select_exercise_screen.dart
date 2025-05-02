import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/services/exercise_service.dart';
import '../../../widgets/exercise_detail_widget.dart';
import '../set/create_set_screen.dart';
import 'add_exercise_screen.dart';
import 'bloc/exercise_bloc.dart';
import 'bloc/exercise_event.dart';
import 'bloc/exercise_state.dart';

class SelectExerciseScreen extends StatefulWidget {
  final String individualTrainingId;
  final DateTime selectedDate;

  const SelectExerciseScreen({
    super.key,
    required this.individualTrainingId,
    required this.selectedDate,
  });

  @override
  SelectExerciseScreenState createState() => SelectExerciseScreenState();
}

class SelectExerciseScreenState extends State<SelectExerciseScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredExercises = [];
  List<Map<String, dynamic>> allExercises = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterExercises);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterExercises);
    searchController.dispose();
    super.dispose();
  }

  void _filterExercises() {
    final query = searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        filteredExercises = List.from(allExercises);
      } else {
        filteredExercises = allExercises
            .where((exercise) {
          final nameLower = exercise['name']?.toLowerCase() ?? '';
          return nameLower.contains(query);
        })
            .toList();
      }
    });
  }

  void _updateExercisesList(List<Map<String, dynamic>> exercises) {
    setState(() {
      allExercises = exercises;
      _filterExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExerciseBloc(
        exerciseService: ExerciseService(),
      )..add(LoadExercises()),
      child: BlocConsumer<ExerciseBloc, ExerciseState>(
        listener: (context, state) {
          if (state is ExercisesLoaded) {
            final exercises = state.exercises.map((exercise) => {
              'id': exercise.id,
              'name': exercise.name,
              'description': exercise.description,
            }).toList();

            _updateExercisesList(exercises);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Додати вправу",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              centerTitle: false,
              leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
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
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextField(searchController, 'Пошук', TextInputType.text, context),
                  const SizedBox(height: 12.0),
                  Expanded(
                    child: _buildExerciseList(context, state),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddExerciseScreen(),
                  ),
                ).then((_) {
                  BlocProvider.of<ExerciseBloc>(context).add(LoadExercises());
                });
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.add, color: Theme.of(context).scaffoldBackgroundColor,),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExerciseList(BuildContext context, ExerciseState state) {
    if (state is ExercisesInitial || state is ExercisesLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ExerciseError) {
      return const Center(child: Text('Додайте улюблену вправу'));
    } else if (filteredExercises.isEmpty) {
      if (searchController.text.isNotEmpty) {
        return Center(child: Text('За запитом "${searchController.text}" нічого не знайдено'));
      }
      return const Center(child: Text('Здається тут пусто :('));
    }

    return SingleChildScrollView(
      child: Column(
        children: filteredExercises.map((exercise) {
          return Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateSetScreen(
                          exerciseId: exercise['id'].toString(),
                          individualTrainingId: widget.individualTrainingId,
                          selectedDate: widget.selectedDate,
                        ),
                      ),
                    ).then((_) {
                      BlocProvider.of<ExerciseBloc>(context).add(LoadExercises());
                    });
                  },
                  child: ExerciseDetailWidget(
                    exerciseName: exercise['name'],
                    description: exercise['description'],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, TextInputType keyboardType, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: _filterExercises,
          ),
        ),
        onChanged: (_) => _filterExercises(),
      ),
    );
  }
}