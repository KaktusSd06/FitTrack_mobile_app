import 'package:fittrack/data/models/gym_model.dart';
import 'package:fittrack/data/services/gym_service.dart';
import 'package:fittrack/presentation/screens/features/gym/bloc/gym_bloc/gym_bloc.dart';
import 'package:fittrack/presentation/screens/features/gym/bloc/gym_bloc/gym_event.dart';
import 'package:fittrack/presentation/screens/features/gym/bloc/gym_bloc/gym_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/select_gym_widget.dart';

class GymListScreen extends StatefulWidget {
  const GymListScreen({super.key});

  @override
  GymListScreenState createState() => GymListScreenState();
}

class GymListScreenState extends State<GymListScreen> {
  final TextEditingController searchController = TextEditingController();
  List<GymModel> filteredGyms = [];
  List<GymModel> allGyms = [];

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
        filteredGyms = List.from(allGyms);
      } else {
        filteredGyms = allGyms
            .where((gym) {
          final nameLower = gym.name.toLowerCase();
          return nameLower.contains(query);
        })
            .toList();
      }
    });
  }

  void _updateGymsList(List<GymModel> gyms) {
    setState(() {
      allGyms = gyms;
      _filterGyms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GymBloc(
        gymService: GymService(),
      )..add(GetAllGyms()),
      child: BlocConsumer<GymBloc, GymState>(
        listener: (context, state) {
          if (state is GymLoaded) {
            _updateGymsList(state.gyms);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Список залів",
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

  Widget _buildGymList(BuildContext context, GymState state) {
    if (state is GymInitial || state is GymLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is GymError) {
      return Center(child: Text('Помилка: ${state.message}'));
    } else if (filteredGyms.isEmpty) {
      if (searchController.text.isNotEmpty) {
        return Center(child: Text('За запитом "${searchController.text}" нічого не знайдено'));
      }
      return const Center(child: Text('Здається тут пусто :('));
    }

    return ListView.separated(
      itemCount: filteredGyms.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final gym = filteredGyms[index];
        return SelectGymWidget(gym: gym);
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