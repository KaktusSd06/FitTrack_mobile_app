import 'package:fittrack/presentation/screens/features/meal/bloc/meal_bloc.dart';
import 'package:fittrack/presentation/screens/features/meal/bloc/meal_event.dart';
import 'package:fittrack/presentation/screens/features/meal/bloc/meal_state.dart';
import 'package:fittrack/presentation/widgets/features/kcal/food_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../dialogs/error_dialog.dart';
import '../../../widgets/features/kcal/kcal_meal_screen_widget.dart';
import '../message_from_trainer/message_screen.dart';
import 'add_meal.dart';
import 'chart/meal_chart_screen.dart';

class MealScreen extends StatefulWidget{
  const MealScreen({super.key});


  @override
  State<MealScreen> createState() => MealScreenState();
}

class MealScreenState extends State<MealScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime startOfWeek = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    getStartOfWeek(selectedDate);
    _loadMealData();
    _scrollController.addListener(_toggleFabVisibility);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_toggleFabVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleFabVisibility() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse && _isFabVisible) {
      setState(() {
        _isFabVisible = false;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward && !_isFabVisible) {
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
      _loadMealData();
    }
  }

  void _selectDateDay(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    _loadMealData();
  }

  void _loadMealData() {
    final date = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    context.read<MealBloc>().add(
      GetUserKcalToday(
        date: date,
      ),
    );
  }

  void _goToPreviousWeek() {
    setState(() {
      startOfWeek = startOfWeek.subtract(const Duration(days: 7));
      selectedDate = startOfWeek;
    });
    _loadMealData();
  }

  void _goToNextWeek() {
    setState(() {
      startOfWeek = startOfWeek.add(const Duration(days: 7));
      selectedDate = startOfWeek;
    });
    _loadMealData();
  }

  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Січень';
      case 2:
        return 'Лютий';
      case 3:
        return 'Березень';
      case 4:
        return 'Квітень';
      case 5:
        return 'Травень';
      case 6:
        return 'Червень';
      case 7:
        return 'Липень';
      case 8:
        return 'Серпень';
      case 9:
        return 'Вересень';
      case 10:
        return 'Жовтень';
      case 11:
        return 'Листопад';
      case 12:
        return 'Грудень';
      default:
        return '';
    }
  }

  String getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'ПН';
      case 2:
        return 'ВТ';
      case 3:
        return 'СР';
      case 4:
        return 'ЧТ';
      case 5:
        return 'ПТ';
      case 6:
        return 'СБ';
      case 7:
        return 'НД';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text('Харчування'),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/message_appbar.svg",
              height: 20,
            ),
            onPressed: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => MessageScreen())
              );
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/statistic_icon.svg",
              height: 20,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MealChartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _goToPreviousWeek,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .cardColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Icon(
                          CupertinoIcons.chevron_back,
                          color: Theme
                              .of(context)
                              .brightness == Brightness.light ? const Color(
                              0xFF8C8C8C) : Theme
                              .of(context)
                              .hintColor,
                          size: 24.0,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .cardColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.calendar_today,
                              color: Theme
                                  .of(context)
                                  .brightness == Brightness.light ? const Color(
                                  0xFF8C8C8C) : Theme
                                  .of(context)
                                  .hintColor,
                              size: 24.0,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              '${getMonthName(
                                  selectedDate.month)} ${selectedDate.year}',
                              style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .brightness == Brightness.light
                                    ? const Color(0xFF8C8C8C)
                                    : Theme
                                    .of(context)
                                    .hintColor,
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
                          color: Theme
                              .of(context)
                              .cardColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Icon(
                          CupertinoIcons.chevron_forward,
                          color: Theme
                              .of(context)
                              .brightness == Brightness.light ? const Color(
                              0xFF8C8C8C) : Theme
                              .of(context)
                              .hintColor,
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
                    color: Theme
                        .of(context)
                        .cardColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      DateTime currentDate = startOfWeek.add(Duration(
                          days: index));
                      bool isSelected = currentDate.day == selectedDate.day &&
                          currentDate.month == selectedDate.month &&
                          currentDate.year == selectedDate.year;

                      return GestureDetector(
                        onTap: () => _selectDateDay(currentDate),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme
                                .of(context)
                                .primaryColor
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
                                      : Theme
                                      .of(context)
                                      .hintColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '${currentDate.day}',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Theme
                                      .of(context)
                                      .brightness == Brightness.light
                                      ? const Color(0xFF8C8C8C)
                                      : Theme
                                      .of(context)
                                      .hintColor,
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

            const SizedBox(height: 12),

            Expanded(
              child: BlocConsumer<MealBloc, MealState>(
                  listener: (context, state) {
                    if (state is MealError) {
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
                    if (state is MealLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    else if (state is MealLoaded) {

                      if(state.meals.isEmpty){
                        return Column(
                          children: [
                            KcalMealScreenWidget(
                              goal: state.goal,
                              kcal: state.kcalToday,
                              selectedDate: selectedDate,
                            ),

                            const SizedBox(height: 140),
                            SvgPicture.asset(
                              "assets/images/food.svg",
                              width: 256,
                            ),
                          ],
                        );
                      }
                      else {
                        return Column(
                          children: [
                            KcalMealScreenWidget(goal: state.goal, kcal: state.kcalToday, selectedDate: selectedDate,),

                            const SizedBox(height: 12),

                            ...state.meals.map((meal) => FoodWidget(id: meal.id!, kcal: meal.calories, name: meal.name, weight: meal.weight)),

                          ],
                        );
                      }
                    }
                    else {
                      return Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 140),
                              SvgPicture.asset(
                                "assets/images/food.svg",
                                width: 256,
                              ),
                            ],
                          )
                      );
                    }
                  }
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: AnimatedOpacity(
        opacity: _isFabVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 400),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>  AddMeal(date: selectedDate),
              ),
            ).then((_) {
              _loadMealData();
            });
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add, color: Theme.of(context).scaffoldBackgroundColor,),
        ),
      ),
    );
  }

}