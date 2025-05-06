import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dialogs/confirmation_dialog.dart';
import '../../../screens/features/meal/bloc/meal_bloc.dart';
import '../../../screens/features/meal/bloc/meal_event.dart';

class FoodWidget extends StatelessWidget {
  final String id;
  final String name;
  final double kcal;
  final int weight;

  const FoodWidget({
    super.key,
    required this.kcal,
    required this.name,
    required this.weight,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 1),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    weight.toInt().toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'г',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              )
            ],
          ),

          Row(
            children: [
              Text(
                kcal.toInt().toString(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                ' kcal',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(width: 20,),
              GestureDetector(
                onTap: (){
                  _onDeleteItem(id: id, context: context);
                },
                child: Icon(Icons.close, color: Theme.of(context).hintColor, size: 22,),
              )
            ],
          )
        ],
      ),
    );
  }

  void _onDeleteItem({required String id, required BuildContext context}){
    final confirmationDialog = ConfirmationDialog();
    confirmationDialog
        .showConfirmationDialog(
        context,
        "Підтвердження видалення",
        "Ви впевнені, що хочете видалити страву?"
    ).then((confirmed) {
      if (confirmed) {
        final mealBloc = context.read<MealBloc>();

        mealBloc.add(DeleteMealById(id: id));

        Future.delayed(const Duration(milliseconds: 300), () {
          mealBloc.add(GetUserKcalToday(date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
        });
      }
    });
  }
}