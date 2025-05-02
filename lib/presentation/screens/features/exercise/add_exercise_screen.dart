import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/models/exercise_model.dart';
import '../../../../data/services/exercise_service.dart';
import 'bloc/exercise_bloc.dart';
import 'bloc/exercise_event.dart';
import 'bloc/exercise_state.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  AddExerciseScreenState createState() => AddExerciseScreenState();
}

class AddExerciseScreenState extends State<AddExerciseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitExercise(BuildContext context) {
    setState(() {
      _isSubmitting = true;
    });

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Будь ласка, заповніть всі поля'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    final exercise = ExerciseModel(
      id: '',
      name: name,
      description: description,
    );

    context.read<ExerciseBloc>().add(AddExercise(exercise));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ExerciseBloc(
            exerciseService: ExerciseService(),
          ),
      child: BlocListener<ExerciseBloc, ExerciseState>(
        listener: (context, state) {
          if (state is ExercisesLoaded && _isSubmitting) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Вправу успішно додано'),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            setState(() {
              _isSubmitting = false;
            });
            Navigator.pop(context);
          } else if (state is ExerciseError && _isSubmitting) {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Здається сталась помилка :('),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            setState(() {
              _isSubmitting = false;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Створити вправу",
              style: Theme
                  .of(context)
                  .textTheme
                  .displayMedium,
            ),
            centerTitle: false,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: IconButton(
                icon: Icon(
                  CupertinoIcons.back,
                  color: Theme
                      .of(context)
                      .hintColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            backgroundColor: Theme
                .of(context)
                .scaffoldBackgroundColor,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Назва",
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                        _nameController, "Введіть назву вправи", TextInputType.text,
                        context),
                    const SizedBox(height: 16),
                    Text(
                      "Опис",
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(_descriptionController, "Введіть опис вправи",
                        TextInputType.multiline, context),
                    const SizedBox(height: 24),
                    Center(
                      child: BlocBuilder<ExerciseBloc, ExerciseState>(
                        builder: (context, state) {
                          return state is ExercisesLoading || _isSubmitting
                              ? const CircularProgressIndicator()
                              : SizedBox(width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _submitExercise(context),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 32.0,
                                ),
                                backgroundColor: Theme
                                    .of(context)
                                    .primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                "Додати",
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headlineMedium?.copyWith(color: Colors.white)
                              ),
                            ),);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, TextInputType keyboardType, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        maxLines: keyboardType == TextInputType.multiline ? 5 : 1,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }
}