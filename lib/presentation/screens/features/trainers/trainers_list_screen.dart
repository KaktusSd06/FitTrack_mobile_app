import 'package:fittrack/data/models/gym_model.dart';
import 'package:fittrack/data/models/trainer_model.dart';
import 'package:fittrack/presentation/screens/features/trainers/bloc/gym_bloc/trainers_event.dart';
import 'package:fittrack/presentation/screens/features/trainers/bloc/gym_bloc/trainers_state.dart';
import 'package:fittrack/presentation/widgets/select_trainer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/trainers_service.dart';
import '../../../widgets/select_gym_widget.dart';
import 'bloc/gym_bloc/trainers_bloc.dart';

class TrainersListScreen extends StatefulWidget {
  final String gymId;
  const TrainersListScreen({required this.gymId, super.key});

  @override
  TrainersListScreenState createState() => TrainersListScreenState();
}

class TrainersListScreenState extends State<TrainersListScreen> {
  final TextEditingController searchController = TextEditingController();
  List<TrainerModel> filteredTrainers = [];
  List<TrainerModel> allTrainers = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterGyms);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterGyms);
    searchController.dispose();
    super.dispose();
  }

  void _filterGyms() {
    final query = searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        filteredTrainers = List.from(allTrainers);
      } else {
        filteredTrainers = allTrainers
            .where((trainers) {
          final nameLower = trainers.lastName.toLowerCase();
          return nameLower.contains(query);
        })
            .toList();
      }
    });
  }

  void _updateGymsList(List<TrainerModel> trainers) {
    setState(() {
      allTrainers = trainers;
      _filterGyms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrainersBloc(
        trainerService: TrainerService(),
      )..add(GetAllTrainersByGymId(gymId: widget.gymId)),
      child: BlocConsumer<TrainersBloc, TrainersState>(
        listener: (context, state) {
          if (state is TrainersLoaded) {
            _updateGymsList(state.trainers);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Обрати тренера",
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
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: _buildGymList(context, state),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGymList(BuildContext context, TrainersState state) {
    if (state is TrainersInitial || state is TrainersLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is TrainersError) {
      return Center(child: Text('Помилка, спробуйте ще раз'));
    } else if (filteredTrainers.isEmpty) {
      if (searchController.text.isNotEmpty) {
        return Center(child: Text('За запитом "${searchController.text}" нічого не знайдено'));
      }
      return const Center(child: Text('Здається тут пусто :('));
    }

    return ListView.separated(
      itemCount: filteredTrainers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final trainer = filteredTrainers[index];
        return SelectTrainerWidget(trainer: trainer);
      },
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
            onPressed: _filterGyms,
          ),
        ),
        onChanged: (_) => _filterGyms(),
      ),
    );
  }
}