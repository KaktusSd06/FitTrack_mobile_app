import 'package:fittrack/presentation/screens/features/sign_in/select_birthday_date_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import '../../../../../core/config/theme.dart' as app_colors;
import 'package:fittrack/presentation/dialogs/lib/presentation/dialogs/error_dialog.dart';
import '../../home_screen.dart';
import 'bloc/sign_in_bloc.dart';
import 'bloc/sign_in_event.dart';
import 'bloc/sign_in_state.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(),
      child: _SignInScreenContent(),
    );
  }
}

class _SignInScreenContent extends StatefulWidget {
  @override
  SignInScreenContentState createState() => SignInScreenContentState();
}

class SignInScreenContentState extends State<_SignInScreenContent> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
            );
          } else if (state is SignInFailure) {
            ErrorDialog().showErrorDialog(
              context,
              "Помилка авторизації",
              "Здається щось пішло не так, спробуйте пізніше",
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 74, bottom: 32),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Вітаємо у",
                          style: Theme
                              .of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 40,
                          ),
                        ),
                        Text(
                          "FitTrack",
                          style: Theme
                              .of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 40,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 124),

                  SvgPicture.asset(
                    "assets/images/sign_in_image.svg",
                    width: 300,
                    //height: 56,
                  ),

                  const SizedBox(height: 44),

                  SizedBox(
                    height: 54,
                    width: double.infinity,
                    child: state is SignInLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SignInButton(
                      buttonType: ButtonType.google,
                      btnText: "Увійти з Google",
                      onPressed: () {
                        context.read<SignInBloc>().add(SignInWithGoogle(context: context));
                      },
                    ),
                  ),


                  Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Правила користування',
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      SizedBox(width: 6,),
                      SvgPicture.asset(
                        "assets/icons/point.svg",
                        width: 4.0,
                        height: 4.0,
                      ),
                      SizedBox(width: 6,),
                      Text(
                        'Політика конфеденційності',
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}