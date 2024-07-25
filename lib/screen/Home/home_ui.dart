import 'package:barber_bloc/Theme/app_colors.dart';
import 'package:barber_bloc/screen/Auth/bloc/auth_bloc.dart';
import 'package:barber_bloc/screen/Auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../Theme/bloc/Them_cubit.dart';
import '../../widget/appbar/basic_app_appbar.dart';
import '../Auth/bloc/auth_state.dart';
import '../Auth/controller/signup_controller.dart';

class HomeUi extends StatelessWidget {
  const HomeUi({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) {
        return BlocProvider(
          create: (context) => AuthBloc()..add(getRequested()),
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeState) {
              final isDarkMode = themeState == ThemeMode.dark;
              return Scaffold(
                body: Center(
                  child: SingleChildScrollView(
                    child: BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.error)),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const CircularProgressIndicator();
                        } else if (state is GetUser) {
                          return Container(
                            color: Colors.red,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Username: ${state.user.username}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? AppColors.lightBackground
                                          : AppColors.darkBackground),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Email: ${state.user.email}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: isDarkMode
                                          ? AppColors.lightBackground
                                          : AppColors.darkBackground),
                                ),
                                Text(
                                  'Role: ${state.user.role}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: isDarkMode
                                          ? AppColors.lightBackground
                                          : AppColors.darkBackground),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Text('No data available or an error occurred');
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
