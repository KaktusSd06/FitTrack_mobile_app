import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import '../../../../../core/config/theme.dart' as app_colors;
import '../../../dialogs/lib/presentation/dialogs/error_dialog.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Sign In",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
            color: Theme.of(context).hintColor,
          ),
        ),
        centerTitle: true,
      ),
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
            padding: const EdgeInsets.only(left: 16, right: 16, top: 120),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/app_logo.svg",
                    width: 66,
                    height: 56,
                    colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
                  ),
                  SizedBox(height: 52),
                  Text(
                    "Вітаємо у",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 40,
                    ),
                  ),
                  Text(
                    "FitTrack",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(height: 52),
                  SizedBox(
                    height: 54,
                    width: double.infinity,
                    child: SignInButton(
                      buttonType: ButtonType.google,
                      onPressed: () {
                        context.read<SignInBloc>().add(SignInWithGoogle(context: context));
                      },
                    )
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}