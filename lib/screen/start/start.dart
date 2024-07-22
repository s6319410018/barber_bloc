import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barber_bloc/Theme/app_colors.dart';
import 'package:barber_bloc/screen/start/bloc/bloc_start_bloc.dart';
import '../../Theme/bloc/Them_cubit.dart';
import '../../widget/button/basic_app_button.dart';
import '../choose_theme/choose_ui.dart';
import 'bloc/bloc_start_event.dart';
import 'bloc/bloc_start_state.dart';

class StartUI extends StatelessWidget {
  const StartUI({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;
    return BlocProvider(
      create: (context) => BlocStartBloc()..add(StartAnimationEvent()),
      child: BlocBuilder<BlocStartBloc, BlocStartState>(
        builder: (context, state) {
          double fadeOpacity = 0.0;
          String displayedText = '';

          if (state is BlocStartFadeState) {
            fadeOpacity = state.opacity;
            if (kDebugMode) {
              print(fadeOpacity);
            }
          }

          if (state is StartTextAnimationState) {
            displayedText = state.displayedText;
          }

          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  "assets/images/start_page.jpg",
                  fit: BoxFit.cover,
                ),
                Container(
                  color: isDarkMode
                      ? AppColors.darkBackground.withOpacity(0.1)
                      : AppColors.lightBackground.withOpacity(0.1),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        displayedText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? AppColors.lightBackground
                              : AppColors.darkBackground,
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 21),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? AppColors.lightBackground
                              : AppColors.darkBackground,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      BasicAppButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const ChooseModePage(),
                            ),
                          );
                        },
                        title: 'Get Started',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
