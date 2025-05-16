import 'package:fittrack/data/services/calories_statistics_service.dart';
import 'package:fittrack/data/services/exercise_service.dart';
import 'package:fittrack/data/services/goal_service.dart';
import 'package:fittrack/data/services/gym_service.dart';
import 'package:fittrack/data/services/individual_training_service.dart';
import 'package:fittrack/data/services/meal_service.dart';
import 'package:fittrack/data/services/membership_service.dart';
import 'package:fittrack/data/services/product_service.dart';
import 'package:fittrack/data/services/set_service.dart';
import 'package:fittrack/data/services/sleep_service.dart';
import 'package:fittrack/data/services/sleep_statistics_service.dart';
import 'package:fittrack/data/services/step_info_service.dart';
import 'package:fittrack/data/services/water_service.dart';
import 'package:fittrack/data/services/weight_service.dart';
import 'package:fittrack/presentation/screens/features/club/bloc/club_bloc.dart';
import 'package:fittrack/presentation/screens/features/goal/bloc/goal_bloc.dart';
import 'package:fittrack/presentation/screens/features/group_trainings/bloc/group_training_bloc.dart';
import 'package:fittrack/presentation/screens/features/group_trainings_history/bloc/group_trainings_history_bloc.dart';
import 'package:fittrack/presentation/screens/features/gym/bloc/gym_bloc/gym_bloc.dart';
import 'package:fittrack/presentation/screens/features/individual_training/bloc/individual_training_bloc.dart';
import 'package:fittrack/presentation/screens/features/meal/bloc/meal_bloc.dart';
import 'package:fittrack/presentation/screens/features/meal/chart/bloc/meal_chart_bloc.dart';
import 'package:fittrack/presentation/screens/features/message_from_trainer/bloc/message_bloc.dart';
import 'package:fittrack/presentation/screens/features/page_with_indicators/bloc/page_with_indicators_bloc.dart';
import 'package:fittrack/presentation/screens/features/profile/bloc/profile_bloc.dart';
import 'package:fittrack/presentation/screens/features/set/bloc/set_bloc.dart';
import 'package:fittrack/presentation/screens/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:fittrack/presentation/screens/features/sleep/bloc/sleep_bloc.dart';
import 'package:fittrack/presentation/screens/features/sleep/bloc_chart/sleep_statistics_bloc.dart';
import 'package:fittrack/presentation/screens/features/step/bloc/step_bloc.dart';
import 'package:fittrack/presentation/screens/features/store/bloc/store_bloc.dart';
import 'package:fittrack/presentation/screens/features/water_info/bloc/water_bloc.dart';
import 'package:fittrack/presentation/screens/features/weight/bloc/weight_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'data/services/group_training_service.dart';
import 'data/services/trainer_messages_service.dart';
import 'data/services/user_service.dart';
import 'logic/bloc/group_training/group_bloc.dart';
import 'logic/bloc/user_update/user_update_bloc.dart';

class AppBlocs {
  static List<BlocProvider> providers = [
    BlocProvider(create: (_) => SignInBloc()),
    BlocProvider(create: (_) => ProfileBloc()),
    BlocProvider<IndividualTrainingBloc>(
      create: (context) => IndividualTrainingBloc(
        trainingService: IndividualTrainingService(),
      ),
    ),
    BlocProvider<SetBloc>(
      create: (context) => SetBloc(
        exerciseService: ExerciseService(),
        setService: SetService(),
      ),
    ),
    BlocProvider<PageWithIndicatorsBloc>(
      create: (context) => PageWithIndicatorsBloc(
        mealService: MealService(),
        goalService: GoalService(),
        weightModel: WeightService(),
        sleepService: SleepService(),
        waterService: WaterService(),
      ),
    ),
    BlocProvider<MealBloc>(
      create: (context) => MealBloc(
        mealService: MealService(),
        goalService: GoalService(),
      ),
    ),
    BlocProvider<GoalBloc>(
      create: (context) => GoalBloc(
        goalService: GoalService(),
      ),
    ),
    BlocProvider<WeightBloc>(
      create: (context) => WeightBloc(
        weightService: WeightService(),
      ),
    ),
    BlocProvider<MealChartBloc>(
      create: (context) => MealChartBloc(
        statisticsService: CaloriesStatisticsService(),
      ),
    ),
    BlocProvider<StepBloc>(
      create: (context) => StepBloc(
        stepsInfoService: StepsInfoService(),
        goalService: GoalService(),
      ),
    ),
    BlocProvider<SleepBloc>(
      create: (context) => SleepBloc(
        sleepService: SleepService(), secureStorage: const FlutterSecureStorage(),
      ),
    ),
    BlocProvider<SleepStatisticsBloc>(
      create: (context) => SleepStatisticsBloc(
        sleepStatisticsService: SleepStatisticsService(),
      ),
    ),
    BlocProvider<WaterBloc>(
      create: (context) => WaterBloc(
        waterService: WaterService(),
      ),
    ),
    BlocProvider<ClubBloc>(
      create: (context) => ClubBloc(
        gymService: GymService(),
        userService: UserService(),
      ),
    ),
    BlocProvider<GroupTrainingBloc>(
      create: (context) => GroupTrainingBloc(
        groupService: GroupTrainingService(),
      ),
    ),
    BlocProvider<GymBloc>(
      create: (context) => GymBloc(
        gymService: GymService(),
      ),
    ),
    BlocProvider<UserUpdateBloc>(
      create: (context) => UserUpdateBloc(
        userService: UserService(),
      ),
    ),
    BlocProvider<StoreBloc>(
      create: (context) => StoreBloc(
        membershipService: MembershipService(),
        productService: ProductService()
      ),
    ),
    BlocProvider<MessageBloc>(
      create: (context) => MessageBloc(
        service: TrainerCommentService(),
      ),
    ),
    BlocProvider<GroupBloc>(
      create: (context) => GroupBloc(
        groupTrainingService: GroupTrainingService(),
      ),
    ),
    BlocProvider<GroupTrainingsHistoryBloc>(
      create: (context) => GroupTrainingsHistoryBloc(
        groupService: GroupTrainingService(),
      ),
    ),
  ];

  static MultiBlocProvider provideBlocsToApp({required Widget child}) {
    return MultiBlocProvider(
      providers: providers,
      child: child,
    );
  }
}