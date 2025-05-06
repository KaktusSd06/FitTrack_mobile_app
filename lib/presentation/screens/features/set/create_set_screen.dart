import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fittrack/data/models/exercise_model.dart';
import 'package:fittrack/data/models/set_model.dart';
import '../../../../data/services/individual_training_service.dart';
import '../../../dialogs/error_dialog.dart';
import 'bloc/set_bloc.dart';
import 'bloc/set_event.dart';
import 'bloc/set_state.dart';

class CreateSetScreen extends StatefulWidget {
  final String exerciseId;
  final String individualTrainingId;
  final DateTime selectedDate;

  const CreateSetScreen({
    super.key,
    required this.exerciseId,
    required this.individualTrainingId,
    required this.selectedDate,
  });

  @override
  State<CreateSetScreen> createState() => _CreateSetScreenState();
}

class _CreateSetScreenState extends State<CreateSetScreen> {
  ExerciseModel? _exercise;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isCreatingTraining = false;

  @override
  void initState() {
    super.initState();
    context.read<SetBloc>().add(LoadExercise(widget.exerciseId));
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _addSetToTraining() async {
    if (_exercise == null) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final double weight = double.parse(_weightController.text);
    final int reps = int.parse(_repsController.text);

    String trainingId = widget.individualTrainingId;

    if(trainingId.isEmpty) {
      setState(() {
        _isCreatingTraining = true;
      });

      try {
        final IndividualTrainingService trainingService = IndividualTrainingService();

        String createdTrainingId = await trainingService.createIndividualTraining(
          date: widget.selectedDate,
        );
        if (createdTrainingId.isEmpty) {
          if (mounted) {
            ErrorDialog().showErrorDialog(
                context,
                "Помилка створення тренування",
                "Не вдалося створити нове тренування. Спробуйте ще раз."
            );
            setState(() {
              _isCreatingTraining = false;
            });
          }
          return;
        }

        trainingId = createdTrainingId;
      } catch (e) {
        if (mounted) {
          ErrorDialog().showErrorDialog(
              context,
              "Помилка",
              "Виникла помилка при створенні тренування"
          );
          setState(() {
            _isCreatingTraining = false;
          });
        }
        return;
      }
    }

    final newSet = SetModel(
      id: '',
      weight: weight,
      reps: reps,
      exerciseId: widget.exerciseId,
      individualTrainingId: trainingId,
      exercise: _exercise,
    );

    context.read<SetBloc>().add(AddSet(newSet));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Створення сета'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: BlocConsumer<SetBloc, SetState>(
        listener: (context, state) {
          if (state is ExerciseLoaded) {
            setState(() {
              _exercise = state.exercise;
            });
          } else if (state is SetAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Сет успішно додано до тренування'),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            Navigator.pop(context);
          } else if (state is SetFailure) {
            setState(() {
              _isCreatingTraining = false;
            });
            ErrorDialog().showErrorDialog(context, "Упс, помилка :(", "Виникла помилка при створенні сета, спробуйте ще раз");
          }
        },
        builder: (context, state) {
          if ((state is SetLoading && _exercise == null) || _isCreatingTraining) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_exercise != null) ...[
                  Text(
                    _exercise!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _exercise!.description ?? 'Опис відсутній',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Form for weight and reps
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Weight field
                        TextFormField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Вага (кг)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            prefixIcon: const Icon(Icons.fitness_center),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Будь ласка, введіть вагу';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Будь ласка, введіть коректне число';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _repsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Кількість повторень',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            prefixIcon: const Icon(Icons.repeat),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Будь ласка, введіть кількість повторень';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Будь ласка, введіть ціле число';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Add set button
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (state is SetLoading || _isCreatingTraining) ? null : _addSetToTraining,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: (state is SetLoading || _isCreatingTraining)
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              'Додати до тренування',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else
                  const Center(
                    child: Text('Інформація про вправу не знайдена'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}