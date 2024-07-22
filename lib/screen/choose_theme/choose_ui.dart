import 'dart:ui';
import 'package:barber_bloc/Theme/app_colors.dart';
import 'package:barber_bloc/Theme/bloc/Them_cubit.dart';
import 'package:barber_bloc/screen/start/start.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widget/button/basic_app_button.dart';

class ChooseModePage extends StatefulWidget {
  const ChooseModePage({super.key});

  @override
  _ChooseModePageState createState() => _ChooseModePageState();
}

class _ChooseModePageState extends State<ChooseModePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDarkMode = themeMode == ThemeMode.dark;
        return Scaffold(
          backgroundColor:
              isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                "assets/images/choose.jpg",
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black.withOpacity(isDarkMode ? 0.8 : 0.0),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      'Choose Mode',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? AppColors.lightBackground
                            : AppColors.darkBackground,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<ThemeCubit>()
                                    .updateTheme(ThemeMode.dark);
                              },
                              child: ClipOval(
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff30393C)
                                          .withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.dark_mode_rounded),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Dark Mode',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: isDarkMode
                                    ? AppColors.lightBackground
                                    : AppColors.darkBackground,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 40),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<ThemeCubit>()
                                    .updateTheme(ThemeMode.light);
                              },
                              child: ClipOval(
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff30393C)
                                          .withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.light_mode_rounded),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Light Mode',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: isDarkMode
                                    ? AppColors.lightBackground
                                    : AppColors.darkBackground,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    BasicAppButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const StartUI(),
                          ),
                        );
                      },
                      title: 'Continue',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
