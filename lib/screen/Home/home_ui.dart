import 'dart:convert'; // Import for base64 decoding
import 'dart:typed_data';

import 'package:barber_bloc/Theme/app_colors.dart';
import 'package:barber_bloc/screen/Auth/bloc/auth_bloc.dart';
import 'package:barber_bloc/screen/Auth/bloc/auth_event.dart';
import 'package:barber_bloc/screen/Auth/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Theme/bloc/Them_cubit.dart';
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
              final textStyle = TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? AppColors.lightBackground
                    : AppColors.darkBackground,
              );

              return BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) async {
                  if (state is AuthFailure) {
                    showTopSnackBar(
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, top: 60),
                      Overlay.of(context),
                      CustomSnackBar.error(
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode
                                ? AppColors.lightBackground.withOpacity(0.3)
                                : AppColors.darkBackground.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          )
                        ],
                        backgroundColor: AppColors.F_Status,
                        message: state.error,
                      ),
                    );

                    await Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const SigninUipage()),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetUser) {
                    final firstName = state.user.profile?['firstName'] ??
                        'No first name available';
                    final lastName = state.user.profile?['lastName'] ??
                        'No last name available';
                    final phoneNumber = state.user.profile?['phoneNumber'] ??
                        'No phone number available';
                    final pictureBase64 = state.user.profile?['picture'];
                    final address = state.user.profile?['address'] ??
                        'No address available';

                    Uint8List? pictureBytes;
                    if (pictureBase64 != null && pictureBase64.isNotEmpty) {
                      try {
                        pictureBytes = base64Decode(pictureBase64);
                      } catch (e) {
                        pictureBytes = null;
                      }
                    }

                    return Scaffold(
                      backgroundColor: isDarkMode
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(
                            56), // Adjust height as needed
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: isDarkMode
                                    ? AppColors.lightBackground.withOpacity(0.5)
                                    : AppColors.darkBackground.withOpacity(0.5),
                                blurRadius:
                                    5, // Increase blurRadius for a larger shadow
                                offset: const Offset(
                                    0, 1), // Adjust offset for shadow position
                              ),
                            ],
                          ),
                          child: AppBar(
                            backgroundColor: isDarkMode
                                ? AppColors.darkBackground
                                : AppColors.lightBackground,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(16)),
                            ),
                            toolbarHeight: 56, // Adjust height as needed
                            centerTitle: true,
                            title: const Text("Barber"),
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: pictureBytes != null
                                  ? Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: isDarkMode
                                                ? AppColors.lightBackground
                                                    .withOpacity(0.5)
                                                : AppColors.darkBackground
                                                    .withOpacity(0.5),
                                            blurRadius:
                                                10, // Increase blurRadius for a larger shadow
                                            offset: const Offset(0,
                                                1), // Adjust offset for shadow position
                                          ),
                                        ],
                                        color: isDarkMode
                                            ? AppColors.lightBackground
                                                .withOpacity(0.3)
                                            : AppColors.darkBackground
                                                .withOpacity(0.3),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: MemoryImage(pictureBytes),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: isDarkMode
                                                ? Colors.black.withOpacity(0.5)
                                                : Colors.grey.withOpacity(0.5),
                                            blurRadius:
                                                10, // Increase blurRadius for a larger shadow
                                            offset: const Offset(0,
                                                4), // Adjust offset for shadow position
                                          ),
                                        ],
                                        color: isDarkMode
                                            ? AppColors.lightBackground
                                                .withOpacity(0.3)
                                            : AppColors.darkBackground
                                                .withOpacity(0.3),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          firstName.isNotEmpty
                                              ? firstName[0]
                                              : '?',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            actions: [
                              IconButton(
                                icon: Icon(isDarkMode
                                    ? Icons.light_mode
                                    : Icons.dark_mode),
                                onPressed: () {
                                  context.read<ThemeCubit>().updateTheme(
                                      isDarkMode
                                          ? ThemeMode.light
                                          : ThemeMode.dark);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      body: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('First Name: $firstName', style: textStyle),
                              Text('Last Name: $lastName', style: textStyle),
                              Text('Phone Number: $phoneNumber',
                                  style: textStyle),
                              Text('Address: $address', style: textStyle),
                              const SizedBox(height: 10),
                              Text('Email: ${state.user.email}',
                                  style: const TextStyle(fontSize: 16)),
                              Text('Role: ${state.user.role}',
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                        child: Text('No data available or an error occurred'));
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
