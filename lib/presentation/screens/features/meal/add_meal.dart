import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fittrack/presentation/screens/features/meal/bloc/meal_bloc.dart';
import 'package:fittrack/presentation/screens/features/meal/bloc/meal_event.dart';
import 'package:fittrack/presentation/screens/features/meal/bloc/meal_state.dart';
import 'package:fittrack/presentation/dialogs/error_dialog.dart';

class AddMeal extends StatefulWidget {
  final DateTime date;

  const AddMeal({super.key, required this.date});

  @override
  State<StatefulWidget> createState() => AddMealState();
}

class AddMealState extends State<AddMeal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _caloriesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final name = _nameController.text;
      final weight = int.parse(_weightController.text);
      final calories = double.parse(_caloriesController.text);
      final date = DateTime(widget.date.year, widget.date.month, widget.date.day);

      context.read<MealBloc>().add(
        CreateMeal(
          date: date,
          name: name,
          weight: weight,
          calories: calories,
        ),
      );
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Будь ласка, введіть назву страви';
    }
    return null;
  }

  String? _validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Будь ласка, введіть вагу страви';
    }
    try {
      final weight = double.parse(value);
      if (weight <= 0) {
        return 'Вага повинна бути більшою за 0';
      }
    } catch (e) {
      return 'Будь ласка, введіть коректне число';
    }
    return null;
  }

  String? _validateCalories(String? value) {
    if (value == null || value.isEmpty) {
      return 'Будь ласка, введіть калорійність страви';
    }
    try {
      final calories = double.parse(value);
      if (calories < 0) {
        return 'Калорійність не може бути від\'ємною';
      }
    } catch (e) {
      return 'Будь ласка, введіть коректне число';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text('Додати страву', style: Theme.of(context).textTheme.displayMedium,),
      ),
      body: BlocConsumer<MealBloc, MealState>(
        listener: (context, state) {
          if (state is MealError) {
            setState(() {
              _isSubmitting = false;
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ErrorDialog().showErrorDialog(
                context,
                "Упс, помилка :(",
                "Не вдалося додати страву. Спробуйте ще раз.",
              );
            });
          }
          if (state is MealCreated) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Назва страви',
                                hintText: 'Введіть назву страви',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                filled: true,
                              ),
                              validator: _validateName,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _weightController,
                              decoration: InputDecoration(
                                labelText: 'Вага (г)',
                                hintText: 'Введіть вагу страви',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                filled: true,
                              ),
                              keyboardType: TextInputType.number,
                              validator: _validateWeight,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _caloriesController,
                              decoration: InputDecoration(
                                labelText: 'Калорії (ккал)',
                                hintText: 'Введіть калорійність страви',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                filled: true,
                              ),
                              keyboardType: TextInputType.number,
                              validator: _validateCalories,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    SizedBox(
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          disabledBackgroundColor: Theme.of(context).disabledColor,
                        ),
                        child: state is MealCreating
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                          'Додати страву',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}