enum Goal {
  water,
  steps,
  calories,
}

extension GoalExtension on Goal {
  String get value {
    switch (this) {
      case Goal.water:
        return "Water";
      case Goal.steps:
        return "Steps";
      case Goal.calories:
        return "Calories";
    }
  }
}
