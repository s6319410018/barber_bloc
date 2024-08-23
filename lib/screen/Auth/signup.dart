import 'package:barber_bloc/Theme/app_colors.dart';
import 'package:barber_bloc/screen/Auth/bloc/auth_event.dart';
import 'package:barber_bloc/screen/Auth/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barber_bloc/screen/Auth/bloc/auth_bloc.dart';
import 'package:barber_bloc/screen/Auth/bloc/auth_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Theme/bloc/Them_cubit.dart';
import '../../model/model_user.dart';
import '../../repository/AuthRepository.dart';
import '../../widget/appbar/basic_app_appbar.dart';
import '../../widget/button/basic_app_button.dart';
import 'controller/signup_controller.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) {
        return RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeState) {
              final isDarkMode = themeState == ThemeMode.dark;
              return Scaffold(
                appBar: _buildAppBar(isDarkMode),
                bottomNavigationBar: _buildSigninText(isDarkMode, context),
                body: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildRegisterText(isDarkMode, context),
                      const SizedBox(height: 50),
                      _buildTextField(
                        controller.usernameController,
                        'Enter Name',
                        isDarkMode,
                        TextInputType.name,
                        context,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller.emailController,
                        'Enter Email',
                        isDarkMode,
                        TextInputType.emailAddress,
                        context,
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordField(controller, isDarkMode, context),
                      const SizedBox(height: 20),
                      _buildRoleField(controller, isDarkMode),
                      const SizedBox(height: 20),
                      BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthFailure) {
                            _showTopSnackBar(isDarkMode, state.error.toString(),
                                context, false);
                          } else if (state is AuthSuccess) {
                            controller.clearFields();
                            _showTopSnackBar(isDarkMode,
                                state.message.toString(), context, true);
                          }
                        },
                        builder: (context, state) {
                          return BasicAppButton(
                            loading: state is AuthLoading,
                            onPressed: () {
                              if (state is AuthLoading) {
                                return;
                              }
                              if (state is AuthInitial ||
                                  state is AuthFailure) {
                                final username =
                                    controller.usernameController.text.trim();
                                final email =
                                    controller.emailController.text.trim();
                                final password =
                                    controller.passwordController.text.trim();
                                final role = controller.dropdownValue.value;
                                if (username.isEmpty ||
                                    email.isEmpty ||
                                    password.isEmpty) {
                                  _showTopSnackBar(
                                    isDarkMode,
                                    "Please Input Data In Form",
                                    context,
                                    false,
                                  );
                                  return;
                                }

                                final user = User(
                                  username: username,
                                  email: email,
                                  password: password,
                                  role: role,
                                );

                                context
                                    .read<AuthBloc>()
                                    .add(RegisterRequestedEvent(user: user));
                              }
                            },
                            title: 'Sign Up',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  BasicAppbar _buildAppBar(bool isDarkMode) {
    return BasicAppbar(
      action: Image.asset(
        isDarkMode
            ? "assets/logos/logo_white.png"
            : "assets/logos/logo_black.png",
      ),
    );
  }

  Widget _buildSigninText(bool isDarkMode, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SigninUipage()),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? \t Sign In',
              style: GoogleFonts.nunito(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                color: isDarkMode
                    ? AppColors.lightBackground
                    : AppColors.darkBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterText(bool isDarkMode, BuildContext context) {
    return Text(
      'Register',
      style: GoogleFonts.nunito(
        fontSize: MediaQuery.of(context).size.width * 0.1,
        color:
            isDarkMode ? AppColors.lightBackground : AppColors.darkBackground,
        shadows: [
          Shadow(
            color: isDarkMode
                ? AppColors.lightBackground.withOpacity(0.3)
                : AppColors.darkBackground.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    bool isDarkMode,
    TextInputType keyboardType,
    BuildContext context,
  ) {
    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        fillColor:
            isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        filled: true,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: isDarkMode
                ? AppColors.lightBackground
                : AppColors.darkBackground,
          ),
        ),
      ),
      style: GoogleFonts.nunito(
        fontSize: MediaQuery.of(context).size.width * 0.035,
        color:
            isDarkMode ? AppColors.lightBackground : AppColors.darkBackground,
        shadows: [
          Shadow(
            color: isDarkMode
                ? AppColors.lightBackground.withOpacity(0.3)
                : AppColors.darkBackground.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
      AuthController controller, bool isDarkMode, BuildContext context) {
    return Obx(
      () => TextField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: controller.obscureText.value,
        controller: controller.passwordController,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              controller.obscureText.value
                  ? FontAwesomeIcons.eyeSlash
                  : FontAwesomeIcons.eye,
              color: isDarkMode
                  ? AppColors.lightBackground
                  : AppColors.darkBackground,
            ),
            onPressed: () => controller.toggleObscureText(),
          ),
          fillColor:
              isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
          filled: true,
          hintText: "Enter Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: isDarkMode
                  ? AppColors.lightBackground
                  : AppColors.darkBackground,
            ),
          ),
        ),
        style: GoogleFonts.nunito(
          fontSize: MediaQuery.of(context).size.width * 0.035,
          color:
              isDarkMode ? AppColors.lightBackground : AppColors.darkBackground,
          shadows: [
            Shadow(
              color: isDarkMode
                  ? AppColors.lightBackground.withOpacity(0.3)
                  : AppColors.darkBackground.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleField(AuthController controller, bool isDarkMode) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.dropdownValue.value,
        items: controller.items
            .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: GoogleFonts.nunito(
                      color: isDarkMode
                          ? AppColors.lightBackground
                          : AppColors.darkBackground,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.dropdownValue.value = newValue;
          }
        },
        decoration: InputDecoration(
          fillColor:
              isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: isDarkMode
                  ? AppColors.lightBackground
                  : AppColors.darkBackground,
            ),
          ),
        ),
      ),
    );
  }

  void _showTopSnackBar(
      bool isDarkMode, String message, BuildContext context, bool status) {
    showTopSnackBar(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 60),
      Overlay.of(context),
      CustomSnackBar.success(
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? AppColors.lightBackground.withOpacity(0.3)
                : AppColors.darkBackground.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        backgroundColor: status ? AppColors.S_Status : AppColors.F_Status,
        message: message,
      ),
    );
  }
}
