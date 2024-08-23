import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:barber_bloc/screen/Home/home_ui.dart';
import 'package:barber_bloc/screen/start/start.dart';
import '../../Theme/bloc/Them_cubit.dart';
import 'bloc/bloc_splash_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlocSplashBloc()..add(StartRedirect()),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocConsumer<BlocSplashBloc, BlocSplashState>(
            listener: (context, state) {
              if (state is BlocSplashHome) {
                print("Navigating to HomeUi");
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeUi()));
              } else if (state is BlocSplashNavigate) {
                print("Navigating to StartUI");
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => StartUI()));
                });
              }
            },
            builder: (context, state) {
              return Scaffold(
                backgroundColor:
                    themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                body: Center(
                  child: AnimatedOpacity(
                    opacity: state is BlocSplashAnimateFadein ? 1.0 : 0.0,
                    duration:
                        const Duration(seconds: 2), // 2 seconds for fade in/out
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Image.asset(
                            themeMode == ThemeMode.dark
                                ? "assets/logos/logo_white.png"
                                : "assets/logos/logo_black.png",
                            fit: BoxFit.contain,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        LoadingAnimationWidget.staggeredDotsWave(
                          color: themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          size: MediaQuery.of(context).size.width * 0.1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
