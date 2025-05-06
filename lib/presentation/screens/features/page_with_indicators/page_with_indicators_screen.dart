import 'package:fittrack/presentation/screens/features/page_with_indicators/bloc/page_with_indicators_bloc.dart';
import 'package:fittrack/presentation/screens/features/page_with_indicators/bloc/page_with_indicators_event.dart';
import 'package:fittrack/presentation/screens/features/page_with_indicators/bloc/page_with_indicators_state.dart';
import 'package:fittrack/presentation/widgets/weight_home_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../dialogs/error_dialog.dart';
import '../../../widgets/features/kcal/kcal_home_screen_widget.dart';

class PageWithIndicatorsScreen extends StatefulWidget{
  const PageWithIndicatorsScreen({super.key});

  @override
  State<PageWithIndicatorsScreen> createState() => PageWithIndicatorsScreenState();
}

class PageWithIndicatorsScreenState extends State<PageWithIndicatorsScreen>{

  @override
  void initState() {
    super.initState();

    _loadPageInfo();
  }

  void _loadPageInfo() {



    context.read<PageWithIndicatorsBloc>().add(
      GetUserKcalSumToday(
        date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
            "FitTrack",
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Theme.of(context).primaryColor
            )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
        child: BlocConsumer<PageWithIndicatorsBloc, PageWithIndicatorsState>(
          listener: (context, state){
            if (state is PageWithIndicatorsError) {
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
            if(state is PageWithIndicatorsLoading){
              return const Center(child: CircularProgressIndicator());
            }
            else if(state is PageWithIndicatorsLoaded){
              return Column(
                children: [
                  KcalHomeScreenWidget(goal: state.goal, kcal: state.kcalToday,),
                  const SizedBox(height: 12,),
                  WeightHomeScreenWidget(weight: state.weight),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(context, MaterialPageRoute(builder: (context) => WeightScreen()));
                  //   },
                  //   child: Text("weight"),
                  // )
                ],
              );
            }
            else {
              return Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      SvgPicture.asset(
                        "assets/images/trainings_empty.svg",
                        width: 177.31,
                        height: 277.4,
                      ),
                    ],
                  )
              );
            }
          }
        ),
      ),
    );
  }
}
